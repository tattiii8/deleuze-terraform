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

variable "enable_mng_auth" {
  type        = bool
  default     = true
  description = "管理APIのワンタイムトークン認証を有効にするかどうか (true/false)"
}

variable "aws_region" {
  type        = string
  default     = "ap-northeast-1"
  description = "AWS リージョン"
}

variable "s3_bucket_name" {
  type        = string
  description = "Deleuze Drive 用の S3 バケット名"
}

variable "aws_access_key_id" {
  type        = string
  sensitive   = true
  description = "S3 アクセス用の AWS Access Key ID"
}

variable "aws_secret_access_key" {
  type        = string
  sensitive   = true
  description = "S3 アクセス用の AWS Secret Access Key"
}