variable "name" {
  type    = string
  default = "jamty" # アプリ名を設定しておく
}

variable "azs" {
  # default = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
  default = ["ap-northeast-1a", "ap-northeast-1c"]
  # default = ["ap-northeast-1a"]
}

variable "domain" {
  description = "Route 53 で管理しているドメイン名"
  type = string
}

variable "rails_env" { type = string }
variable "rails_log_to_stdout" { type = string }
variable "devise_jwt_secret_key" { type = string }
variable "api_key" { type = string }
variable "api_domain" { type = string }

variable "db_username" { type = string }
variable "db_password" { type = string }
variable "db_database" { type = string }
