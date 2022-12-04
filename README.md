# 環境構築
```bash
# docker image作成
docker-compose build
```

# Railsの起動
`.env.sample`をコピーして`.env.development`を作成し、環境変数を設定しておく

## Nginxを使う場合
```bash
docker-compose up
```

## Nginxを使わない場合
コンテナ起動する前に`docker-compose.yml`のNginx部分をコメントアウトしておく。
```bash
# デーモンモードでコンテナ起動 && Railsのコンテナに入る
docker-compose up -d && docker-compose exec backend bash

# Rails起動（pumaの設定変更しているので -b 0.0.0.0 は不要）
bundle exec rails s

# コンテナ削除
Ctrl + D
docker-compose down
```

# TerraformでAWS環境を構築
手順
- `terraform/terraform.tfvars.sample`をコピーして`terraform/terraform.tfvars`を作成し、環境変数を設定しておく
- docker image を再作成して、AWS ECR に push する
- terraformコマンドでAWS環境を更新する
```bash
# 事前確認
terraform plan

# AWS環境を構築
terraform apply
```
