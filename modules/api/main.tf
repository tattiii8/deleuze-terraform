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
    AUTH_INTERNAL_URL                    = var.auth_internal_url
  }
}

resource "nomad_variable" "mng" {
  path = "nomad/jobs/deleuze-mng"

  items = {
    ASPNETCORE_ENVIRONMENT             = var.aspnetcore_environment
    ASPNETCORE_URLS                    = "http://+:${tostring(var.mng_port)}"
    ConnectionStrings__AuthConnection = "Host=${var.host_ip};Port=${tostring(var.auth_db_port)};Database=${var.auth_db_name};Username=${var.db_user};Password=${var.db_password}"
    MANAGEMENT_API_SECRET             = var.management_api_secret
    ENABLE_MNG_AUTH                   = tostring(var.enable_mng_auth)
    Services__Drive__InternalApiUrl   = "http://${var.host_ip}:${tostring(var.drive_port)}"
  }
}

resource "nomad_variable" "drive" {
  path = "nomad/jobs/deleuze-drive"

  items = {
    ASPNETCORE_ENVIRONMENT               = var.aspnetcore_environment
    ASPNETCORE_URLS                      = "http://+:${tostring(var.drive_port)}"
    ConnectionStrings__DefaultConnection = "Host=${var.host_ip};Port=${tostring(var.drive_db_port)};Database=${var.drive_db_name};Username=${var.db_user};Password=${var.db_password}"
    AUTH_EXTERNAL_URL                    = var.auth_external_url
    AUTH_INTERNAL_URL                    = var.auth_internal_url
    AWS__Region                          = var.aws_region
    AWS__BucketName                      = var.s3_bucket_name
    AWS_ACCESS_KEY_ID                    = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY                = var.aws_secret_access_key
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

# 3. Management サービス
resource "nomad_job" "deleuze-mng" {
  jobspec = templatefile("${path.module}/templates/deleuze-mng.nomad.hcl.tpl", {
    datacenter   = var.datacenter
    ecr_registry = var.ecr_registry
    image_tag    = var.image_tag
    mng_port     = var.mng_port
    drive_port   = var.drive_port
  })

  depends_on = [nomad_variable.mng]
}

resource "nomad_job" "deleuze-drive" {
  jobspec = templatefile("${path.module}/templates/deleuze-drive.nomad.hcl.tpl", {
    datacenter   = var.datacenter
    ecr_registry = var.ecr_registry
    image_tag    = var.image_tag
    drive_port   = var.drive_port
  })

  depends_on = [nomad_variable.drive]
}