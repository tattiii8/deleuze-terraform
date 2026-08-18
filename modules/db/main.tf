resource "nomad_job" "db" {
  jobspec = templatefile("${path.module}/templates/db.nomad.hcl.tpl", {
    datacenter  = var.datacenter
    db_user     = var.db_user
    db_password = var.db_password
    auth_db_name = var.auth_db_name
    app_db_name  = var.app_db_name
    auth_db_port = var.auth_db_port
    app_db_port  = var.app_db_port
  })
}