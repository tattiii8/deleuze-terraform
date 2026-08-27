resource "nomad_variable" "drive_db" {
  path = "nomad/jobs/flaubert-drive-db"

  items = {
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_DB       = var.drive_db_name
  }
}

resource "nomad_job" "flaubert_drive_db" {
  jobspec = templatefile("${path.module}/templates/flaubert-drive-db.nomad.hcl.tpl", {
    datacenter    = var.datacenter
    ecr_registry  = var.ecr_registry
    drive_db_port = var.drive_db_port
  })

  depends_on = [nomad_variable.drive_db]
}
