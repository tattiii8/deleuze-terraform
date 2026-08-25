# =========================================================
# 1-1. Deleuze Auth DB
# =========================================================
resource "nomad_variable" "auth_db" {
  path = "nomad/jobs/deleuze-auth-db"

  items = {
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_DB       = var.auth_db_name
  }
}


# =========================================================
# 1-2. Deleuze Management DB
# =========================================================
resource "nomad_variable" "mng_db" {
  path = "nomad/jobs/deleuze-mng-db"

  items = {
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_DB       = var.mng_db_name
  }
}


# =========================================================
# 1-3. Deleuze Drive DB
# =========================================================
resource "nomad_variable" "drive_db" {
  path = "nomad/jobs/deleuze-drive-db"

  items = {
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_DB       = var.drive_db_name
  }
}


# =========================================================
# DB Job
# =========================================================
resource "nomad_job" "db" {
  jobspec = templatefile(
    "${path.module}/templates/db.nomad.hcl.tpl",
    {
      datacenter    = var.datacenter
      ecr_registry  = var.ecr_registry
      auth_db_port  = var.auth_db_port
      mng_db_port   = var.mng_db_port
      drive_db_port = var.drive_db_port
    }
  )

  depends_on = [
    nomad_variable.auth_db,
    nomad_variable.mng_db,
    nomad_variable.drive_db
  ]
}