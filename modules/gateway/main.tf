resource "nomad_job" "gateway" {
  jobspec = templatefile("${path.module}/templates/gateway.nomad.hcl.tpl", {
    datacenter              = var.datacenter
    ecr_registry            = var.ecr_registry
    cloudflare_tunnel_token = var.cloudflare_tunnel_token
    host_ip                 = var.host_ip
    auth_port               = var.auth_port
    app_port                = var.app_port
    mng_port                = var.mng_port
  })
}