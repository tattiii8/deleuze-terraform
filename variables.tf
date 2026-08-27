variable "nomad_address" { type = string }
variable "datacenter" { type = string }
variable "aws_account_id" { type = string }
variable "aws_region" { type = string }
variable "cloudflare_tunnel_token" {
  type      = string
  sensitive = true
}
variable "host_ip" {
  type        = string
  description = "Target host IP address for the Drive database"
}
variable "db_password" {
  type        = string
  sensitive   = true
  description = "PostgreSQL password for flaubert-drive"
}
variable "drive_db_port" {
  type        = number
  default     = 5452
  description = "PostgreSQL port for flaubert-drive"
}
variable "image_tag" { type = string }
variable "aspnetcore_environment" { type = string }
variable "s3_bucket_name" { type = string }
variable "aws_access_key_id" {
  type      = string
  sensitive = true
}
variable "aws_secret_access_key" {
  type      = string
  sensitive = true
}
