# terraform init -backend-config=tfbackend.conf

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.1"
    }
  }
}

provider "nomad" {
  address = var.nomad_address
}

locals {
  ecr_registry  = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
  auth_port     = 5001
  app_port      = 5002
  mng_port      = 5003
  drive_port    = 5004
  auth_db_port  = 5432
  app_db_port   = 5433
  drive_db_port = 5434
  mng_front_port = 8891
  auth_db_name  = "deleuze-auth"
  app_db_name   = "deleuze-app"
  drive_db_name = "deleuze-drive" # deleuze-app から修正
  db_user       = "deleuzeadmin"
}

# 1. Database
module "db" {
  source        = "././modules/db"
  datacenter    = var.datacenter
  db_user       = local.db_user
  db_password   = var.db_password
  auth_db_name  = local.auth_db_name
  app_db_name   = local.app_db_name
  drive_db_name = local.drive_db_name
  auth_db_port  = local.auth_db_port
  app_db_port   = local.app_db_port
  drive_db_port = local.drive_db_port
  ecr_registry  = local.ecr_registry
}

# 2. Application API Services
module "api" {
  source                 = "././modules/api"
  datacenter             = var.datacenter
  ecr_registry           = local.ecr_registry
  image_tag              = var.image_tag
  aspnetcore_environment = var.aspnetcore_environment
  host_ip                = var.host_ip
  auth_port              = local.auth_port
  app_port               = local.app_port
  mng_port               = local.mng_port
  drive_port             = local.drive_port # 追加

  db_user       = local.db_user
  db_password   = var.db_password
  auth_db_name  = local.auth_db_name
  app_db_name   = local.app_db_name
  drive_db_name = local.drive_db_name # 追加
  auth_db_port  = local.auth_db_port
  app_db_port   = local.app_db_port
  drive_db_port = local.drive_db_port # 追加

  auth_external_url     = "https://deleuze.lesure.net/api/auth"
  management_api_secret = var.management_api_secret
  enable_mng_auth       = var.enable_mng_auth

  s3_bucket_name          = var.s3_bucket_name
  aws_region              = var.aws_region
  aws_access_key_id       = var.aws_access_key_id
  aws_secret_access_key   = var.aws_secret_access_key

  depends_on = [module.db]
}

# 3. Gateway    
module "gateway" {
  source                  = "././modules/gateway"
  datacenter              = var.datacenter
  ecr_registry            = local.ecr_registry
  cloudflare_tunnel_token = var.cloudflare_tunnel_token
  host_ip                 = var.host_ip
  auth_port               = local.auth_port
  app_port                = local.app_port
  mng_port                = local.mng_port
  drive_port              =  local.drive_port
  mng_front_port          =  local.mng_front_port

  depends_on = [module.api]
}