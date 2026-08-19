resource "nomad_job" "api" {
  jobspec = templatefile("${path.module}/templates/api.nomad.hcl.tpl", {
    datacenter             = var.datacenter
    ecr_registry           = var.ecr_registry
    image_tag              = var.image_tag
    aspnetcore_environment = var.aspnetcore_environment
    host_ip                = var.host_ip
    auth_port              = var.auth_port
    app_port               = var.app_port
    mng_port               = var.mng_port
    db_user                = var.db_user
    db_password            = var.db_password
    auth_db_name           = var.auth_db_name
    app_db_name            = var.app_db_name
    auth_db_port           = var.auth_db_port
    app_db_port            = var.app_db_port
    auth_external_url      = var.auth_external_url
    management_api_secret  = var.management_api_secret
    enable_mng_auth        = var.enable_mng_auth
  })
}