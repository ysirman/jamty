variable "name" { type = string }
variable "vpc_id" { type = string }
variable "https_listener_arn" { type = string }
variable "cluster_name" { type = string }
variable "subnet_ids" { type = list }
variable "db_host" { type = string }
variable "db_username" { type = string }
variable "db_password" { type = string }
variable "db_database" { type = string }
variable "rails_env" { type = string }
variable "rails_log_to_stdout" { type = string }
variable "devise_jwt_secret_key" { type = string }
variable "api_key" { type = string }
variable "api_domain" { type = string }