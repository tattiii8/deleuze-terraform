variable "datacenter" { type = string }
variable "ecr_registry" { type = string }
variable "image_tag" { type = string }
variable "aspnetcore_environment" { type = string }
variable "host_ip" { type = string }
variable "drive_port" { type = number }
variable "db_user" { type = string }
variable "db_password" {
  type      = string
  sensitive = true
}
variable "drive_db_name" { type = string }
variable "drive_db_port" { type = number }
variable "aws_region" { type = string }
variable "s3_bucket_name" { type = string }
variable "aws_access_key_id" {
  type      = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}
