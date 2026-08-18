variable "nomad_address" {
  type        = string
  description = "Nomad server HTTP API endpoint"
}

variable "datacenter" {
  type        = string
  description = "Target Nomad datacenter"
}

variable "aws_account_id" {
  type        = string
  description = "12-digit AWS Account ID for ECR registry"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "cloudflare_tunnel_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare Tunnel secret token"
}

variable "host_ip" {
  type        = string
  description = "Target host IP address for internal routing"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "PostgreSQL password for databases"
}

variable "management_api_secret" {
  type        = string
  sensitive   = true
  description = "Secret key for Management API authorization"
}

variable "image_tag" {
  type        = string
  description = "Container image tag version"
}

variable "aspnetcore_environment" {
  type        = string
  description = "ASPNETCORE_ENVIRONMENT setting (e.g. Development, Production)"
}