variable "datacenter" { type = string }
variable "db_user" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "auth_db_name" { type = string }
variable "app_db_name" { type = string }
variable "drive_db_name" { type = string } # 追加

variable "auth_db_port" { type = number }
variable "app_db_port" { type = number }
variable "drive_db_port" { type = number } # 追加

variable "drive_db_name" {
  type        = string
  description = "Database name for deleuze-drive"
}

variable "drive_db_port" {
  type        = number
  description = "Database port for deleuze-drive"
}

variable "ecr_registry" {
  type        = string
  description = "ECR registry URL/domain"
}