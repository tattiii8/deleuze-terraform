# terraform init -backend-config=tfbackend.conf

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    nomad = {
      source  = "hashicorp/nomad"
      version = "~> 2.1"
    }
  }
  backend "s3" {}
}

provider "nomad" {
  address = var.nomad_address
}

locals {
  ecr_registry  = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
  drive_port    = 5005
  drive_db_name = "flaubert-drive"
  db_user       = "flaubertadmin"
}

module "db" {
  source        = "./modules/db"
  datacenter    = var.datacenter
  db_user       = local.db_user
  db_password   = var.db_password
  drive_db_name = local.drive_db_name
  drive_db_port = var.drive_db_port
  ecr_registry  = local.ecr_registry
}

module "drive" {
  source                 = "./modules/api"
  datacenter             = var.datacenter
  ecr_registry           = local.ecr_registry
  image_tag              = var.image_tag
  aspnetcore_environment = var.aspnetcore_environment
  host_ip                = var.host_ip
  drive_port             = local.drive_port
  db_user                = local.db_user
  db_password            = var.db_password
  drive_db_name          = local.drive_db_name
  drive_db_port          = var.drive_db_port
  aws_region             = var.aws_region
  s3_bucket_name         = var.s3_bucket_name
  aws_access_key_id      = var.aws_access_key_id
  aws_secret_access_key  = var.aws_secret_access_key

  depends_on = [module.db]
}

module "gateway" {
  source                  = "./modules/gateway"
  datacenter              = var.datacenter
  ecr_registry            = local.ecr_registry
  cloudflare_tunnel_token = var.cloudflare_tunnel_token
  host_ip                 = var.host_ip
  drive_port              = local.drive_port

  depends_on = [module.drive]
}
