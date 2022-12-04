data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
locals {
  name = "${var.name}-rails"
  account_id = "${data.aws_caller_identity.current.account_id}" # アカウントID
  region = "${data.aws_region.current.name}" # プロビジョニングを実行するリージョン
}

######################################################################
resource "aws_lb_target_group" "this" {
  name = "${local.name}"

  vpc_id = "${var.vpc_id}" # ターゲットグループを作成するVPC

  # ALBからECSタスクのコンテナへトラフィックを振り分ける設定
  port        = 80
  target_type = "ip"
  protocol    = "HTTP"

  # コンテナへの死活監視設定
  health_check {
    interval            = 300
    path                = "/healthcheck"
    port                = 80
    protocol            = "HTTP"
    timeout             = 30
    unhealthy_threshold = 2 # 設定回数失敗したらunhealthyになる
    matcher             = 200
  }
}

######################################################################
data "template_file" "container_definitions" {
  template = "${file("./ecs_rails/container_definitions.json")}"

  vars = {
    tag = "latest"

    name = "${local.name}"

    account_id = "${local.account_id}"
    region     = "${local.region}"

    rails_env = "${var.rails_env}"
    rails_log_to_stdout = "${var.rails_log_to_stdout}"
    devise_jwt_secret_key = "${var.devise_jwt_secret_key}"
    api_key = "${var.api_key}"
    api_domain = "${var.api_domain}"
    db_host = "${var.db_host}"
    db_username = "${var.db_username}"
    db_password = "${var.db_password}"
    db_database = "${var.db_database}"
  }
}

resource "aws_ecs_task_definition" "this" {
  family = "${local.name}"

  # 起動するコンテナの定義
  container_definitions = "${data.template_file.container_definitions.rendered}"

  # ECSタスクが使用可能なリソースの上限
  # タスク内のコンテナはこの上限内に使用するリソースを収める必要があり、メモリが上限に達した場合OOM Killer にタスクがキルされる
  cpu    = 256 # 1024 # 512
  memory = 512 # 2048 # 1024

  network_mode             = "awsvpc" # ECSタスクのネットワークドライバ。Fargateを使用する場合は"awsvpc"決め打ち
  requires_compatibilities = ["FARGATE"] # データプレーンの選択

  task_role_arn      = "${aws_iam_role.task_execution.arn}"
  execution_role_arn = "${aws_iam_role.task_execution.arn}"
}

######################################################################
resource "aws_cloudwatch_log_group" "this" {
  name              = "/${local.name}/ecs"
  retention_in_days = "7"
}

resource "aws_iam_role" "task_execution" {
  name = "${local.name}-TaskExecution"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "task_execution" {
  role = "${aws_iam_role.task_execution.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# ECS Exec用のポリシー
# https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/userguide/ecs-exec.html
resource "aws_iam_role_policy" "ecs_exec" {
  role = "${aws_iam_role.task_execution.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssmmessages:CreateControlChannel",
        "ssmmessages:CreateDataChannel",
        "ssmmessages:OpenControlChannel",
        "ssmmessages:OpenDataChannel"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = "${aws_iam_role.task_execution.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

######################################################################
resource "aws_lb_listener_rule" "this" {
  # ルールを追加するリスナー
  listener_arn = "${var.https_listener_arn}"

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.this.id}"
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

######################################################################
resource "aws_security_group" "this" {
  name        = "${local.name}"
  description = "${local.name}"

  # セキュリティグループを配置するVPC
  vpc_id = "${var.vpc_id}"

  # セキュリティグループ内のリソースからインターネットへのアクセス許可設定
  # 今回の場合DockerHubへのPullに使用する
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.name}"
  }
}

resource "aws_security_group_rule" "this_http" {
  security_group_id = "${aws_security_group.this.id}"

  # インターネットからセキュリティグループ内のリソースへのアクセス許可設定
  type = "ingress"

  # TCPでの80ポートへのアクセスを許可する
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

######################################################################
resource "aws_ecs_service" "this" {
  # 依存関係の記述
  # "aws_lb_listener_rule.this" リソースの作成が完了するのを待ってから当該リソースの作成を開始する。
  # "depends_on" は "aws_ecs_service" リソース専用のプロパティではなく、Terraformのシンタックスのため他の"resource"でも使用可能
  depends_on = [aws_lb_listener_rule.this]

  name = "${local.name}"
  launch_type = "FARGATE" # データプレーンとしてFargateを使用する
  desired_count = 1 # ECSタスクの起動数を定義。設定が 1 の場合は、常に1つのタスクが稼働する状態になる
  cluster = "${var.cluster_name}" # 当該ECSサービスを配置するECSクラスターの指定
  health_check_grace_period_seconds = 300 # ヘルスチェック猶予期間。適切な値を設定しないとすぐにタスクが削除されて タスク削除&作成 が無限ループする
  task_definition = "${aws_ecs_task_definition.this.arn}" # 起動するECSタスクのタスク定義

  # ECS Exec を使用可能にする
  enable_execute_command = true

  # ECSタスクへ設定するネットワークの設定
  network_configuration {
    subnets         = var.subnet_ids[0] # タスクの起動を許可するサブネット
    security_groups = ["${aws_security_group.this.id}"] # タスクに紐付けるセキュリティグループ
  }

  # ECSタスクの起動後に紐付けるELBターゲットグループ
  load_balancer {
    target_group_arn = "${aws_lb_target_group.this.arn}"
    container_name   = "jamty-nginx"
    container_port   = "80"
  }
}
