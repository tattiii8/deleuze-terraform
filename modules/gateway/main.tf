resource "nomad_variable" "gateway" {
  path = "nomad/jobs/flaubert-gateway"

  items = {
    CLOUDFLARE_TUNNEL_TOKEN = var.cloudflare_tunnel_token
    HOST_IP                 = var.host_ip
    DRIVE_PORT              = tostring(var.drive_port)
  }
}

resource "nomad_job" "flaubert_gateway" {
  jobspec = templatefile("${path.module}/templates/flaubert-gateway.nomad.hcl.tpl", {
    datacenter   = var.datacenter
    ecr_registry = var.ecr_registry
  })

  depends_on = [nomad_variable.gateway]
}
