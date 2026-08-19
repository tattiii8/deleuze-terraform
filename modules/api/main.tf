# ==========================================
# 1. Nomad Variables の定義
# (Nomad GUI 上の /nomad/jobs/**** で確認・管理可能になります)
# ==========================================

resource "nomad_variable" "auth" {
  path = "nomad/jobs/deleuze-auth"

  items = {
    ASPNETCORE_ENVIRONMENT               = var.aspnetcore_environment
    ASPNETCORE_URLS                      = "http://+:${tostring(var.auth_port)}"
    ConnectionStrings__DefaultConnection = "Host=${var.host_ip};Port=${tostring(var.auth_db_port)};Database=${var.auth_db_name};Username=${var.db_user};Password=${var.db_password}"
    AUTH_EXTERNAL_URL                    = var.auth_external_url
    AUTH_INTERNAL_URL                    = "http://${var.host_ip}:${tostring(var.auth_port)}"
  }
}

resource "nomad_variable" "app" {
  path = "nomad/jobs/deleuze-app"

  items = {
    ASPNETCORE_ENVIRONMENT           = var.aspnetcore_environment
    ASPNETCORE_URLS                  = "http://+:${tostring(var.app_port)}"
    ConnectionStrings__AppConnection = "Host=${var.host_ip};Port=${tostring(var.app_db_port)};Database=${var.app_db_name};Username=${var.db_user};Password=${var.db_password}"
    AUTH_EXTERNAL_URL                = var.auth_external_url
    AUTH_INTERNAL_URL                = "http://${var.host_ip}:${tostring(var.auth_port)}"
  }
}

resource "nomad_variable" "mng" {
  path = "nomad/jobs/deleuze-mng"

  items = {
    ASPNETCORE_ENVIRONMENT             = var.aspnetcore_environment
    ASPNETCORE_URLS                    = "http://+:${tostring(var.mng_port)}"
    ConnectionStrings__AuthConnection = "Host=${var.host_ip};Port=${tostring(var.auth_db_port)};Database=${var.auth_db_name};Username=${var.db_user};Password=${var.db_password}"
    ConnectionStrings__AppConnection  = "Host=${var.host_ip};Port=${tostring(var.app_db_port)};Database=${var.app_db_name};Username=${var.db_user};Password=${var.db_password}"
    MANAGEMENT_API_SECRET             = var.management_api_secret
    ENABLE_MNG_AUTH                   = tostring(var.enable_mng_auth)
  }
}

# ==========================================
# 2. Nomad Job の定義
# ==========================================

# 1. Auth サービス
resource "nomad_job" "deleuze-auth" {
  jobspec = templatefile("${path.module}/templates/deleuze-auth.nomad.hcl.tpl", {
    datacenter   = var.datacenter
    ecr_registry = var.ecr_registry
    image_tag    = var.image_tag
    auth_port    = var.auth_port
  })

  depends_on = [nomad_variable.auth]
}

# 2. App サービス
resource "nomad_job" "deleuze-app" {
  jobspec = templatefile("${path.module}/templates/deleuze-app.nomad.hcl.tpl", {
    datacenter   = var.datacenter
    ecr_registry = var.ecr_registry
    image_tag    = var.image_tag
    app_port     = var.app_port
  })

  depends_on = [nomad_variable.app]
}

# 3. Management サービス
resource "nomad_job" "deleuze-mng" {
  jobspec = templatefile("${path.module}/templates/deleuze-mng.nomad.hcl.tpl", {
    datacenter   = var.datacenter
    ecr_registry = var.ecr_registry
    image_tag    = var.image_tag
    mng_port     = var.mng_port
  })

  depends_on = [nomad_variable.mng]
}