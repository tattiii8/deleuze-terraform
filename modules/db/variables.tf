variable "datacenter" { type = string }
variable "db_user" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "drive_db_name" { type = string }
variable "drive_db_port" { type = number }
variable "ecr_registry" { type = string }
