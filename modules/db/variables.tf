variable "datacenter" { type = string }
variable "db_user" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "auth_db_name" { type = string }
variable "app_db_name" { type = string }
variable "auth_db_port" { type = number }
variable "app_db_port" { type = number }