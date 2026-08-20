terraform {
  backend "s3" {
    bucket = "deleuze-terraform"
    key    = "prod/terraform.tfstate"
    region = "ap-northeast-1"
  }
}