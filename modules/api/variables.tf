variable "datacenter" { type = string }
variable "ecr_registry" { type = string }
variable "image_tag" { type = string }
variable "aspnetcore_environment" { type = string }
variable "host_ip" { type = string }
variable "auth_port" { type = number }
variable "app_port" { type = number }
variable "mng_port" { type = number }

variable "db_user" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "auth_db_name" { type = string }
variable "app_db_name" { type = string }
variable "auth_db_port" { type = number }
variable "app_db_port" { type = number }

variable "drive_port" {
  type        = number
  description = "Port number for deleuze-drive API"
}

variable "drive_db_name" {
  type        = string
  description = "Database name for deleuze-drive"
}

variable "drive_db_port" {
  type        = number
  description = "Database port for deleuze-drive"
}

variable "auth_external_url" { type = string }
variable "management_api_secret" {
  type      = string
  sensitive = true
}

variable "enable_mng_auth" {
  type        = bool
  default     = true
  description = "管理APIのワンタイムトークン認証を有効にするかどうか (true/false)"
}
