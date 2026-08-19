# 1-1. 認証用 DB
resource "nomad_variable" "auth_db" {
  path = "nomad/jobs/deleuze-auth-db"

  items = {
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_DB       = var.auth_db_name
  }
}

# 1-2. アプリ用 DB
resource "nomad_variable" "app_db" {
  path = "nomad/jobs/deleuze-app-db"

  items = {
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_DB       = var.app_db_name
  }
}

# 1-3. ドライブ用 DB（追加）
resource "nomad_variable" "drive_db" {
  path = "nomad/jobs/deleuze-drive-db"

  items = {
    POSTGRES_USER     = var.db_user
    POSTGRES_PASSWORD = var.db_password
    POSTGRES_DB       = var.drive_db_name
  }
}

resource "nomad_job" "db" {
  jobspec = templatefile("${path.module}/templates/db.nomad.hcl.tpl", {
    datacenter    = var.datacenter
    ecr_registry  = var.ecr_registry
    auth_db_port  = var.auth_db_port
    app_db_port   = var.app_db_port
    drive_db_port = var.drive_db_port # 追加
  })

  depends_on = [
    nomad_variable.auth_db,
    nomad_variable.app_db,
    nomad_variable.drive_db # 追加
  ]
}