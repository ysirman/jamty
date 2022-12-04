provider "aws" {
  region = "ap-northeast-1"
}

module "network" {
  source = "./network"
  name = "${var.name}"
  azs = "${var.azs}"
}

module "acm" {
  source = "./acm"
  name = "${var.name}"
  domain = "${var.domain}"
}

module "elb" {
  source = "./elb"
  name = "${var.name}"
  vpc_id = "${module.network.vpc_id}"
  public_subnet_ids = "${module.network.public_subnet_ids}"
  domain = "${var.domain}"
  acm_id = "${module.acm.acm_id}"
}

module "rds" {
  source = "./rds"
  name = "${var.name}"
  vpc_id = "${module.network.vpc_id}"
  subnet_ids = "${module.network.private_subnet_ids}"
  database_name = var.db_database
  master_username = var.db_username
  master_password = var.db_password
}

module "ecs_cluster" {
  source = "./ecs_cluster"
  name = "${var.name}"
}

module "ecs_rails" {
  source = "./ecs_rails"
  name = "${var.name}"
  cluster_name = "${module.ecs_cluster.cluster_name}"
  vpc_id = "${module.network.vpc_id}"
  subnet_ids = "${module.network.private_subnet_ids}"
  https_listener_arn = "${module.elb.https_listener_arn}"

  rails_env = var.rails_env
  rails_log_to_stdout = var.rails_log_to_stdout
  devise_jwt_secret_key = var.devise_jwt_secret_key
  api_key = var.api_key
  api_domain = var.api_domain

  db_host = module.rds.endpoint
  db_username = var.db_username
  db_password = var.db_password
  db_database = var.db_database
}
