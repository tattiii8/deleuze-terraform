variable "datacenter" { type = string }
variable "db_user" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "auth_db_name" { type = string }
variable "mng_db_name" { type = string }


variable "auth_db_port" { type = number }
variable "mng_db_port" { type = number }

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