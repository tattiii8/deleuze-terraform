
resource "nomad_variable" "gateway" {
  path = "nomad/jobs/deleuze-gateway"

  items = {
    CLOUDFLARE_TUNNEL_TOKEN = var.cloudflare_tunnel_token
    HOST_IP                 = var.host_ip
    MNG_FRONT_PORT          = tostring(var.mng_front_port)
    AUTH_PORT               = tostring(var.auth_port)
    APP_PORT                = tostring(var.app_port)
    MNG_PORT                = tostring(var.mng_port)
    DRIVE_PORT              = tostring(var.drive_port)
  }
}


resource "nomad_job" "gateway" {
  jobspec = templatefile("${path.module}/templates/gateway.nomad.hcl.tpl", {
    datacenter   = var.datacenter
    ecr_registry = var.ecr_registry
  })

  depends_on = [nomad_variable.gateway]
}