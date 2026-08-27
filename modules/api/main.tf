resource "nomad_variable" "drive" {
  path = "nomad/jobs/flaubert-drive"

  items = {
    ASPNETCORE_ENVIRONMENT               = var.aspnetcore_environment
    ASPNETCORE_URLS                      = "http://+:${tostring(var.drive_port)}"
    ConnectionStrings__DefaultConnection = "Host=${var.host_ip};Port=${tostring(var.drive_db_port)};Database=${var.drive_db_name};Username=${var.db_user};Password=${var.db_password}"
    AWS__Region                          = var.aws_region
    AWS__BucketName                      = var.s3_bucket_name
    AWS_ACCESS_KEY_ID                    = var.aws_access_key_id
    AWS_SECRET_ACCESS_KEY                = var.aws_secret_access_key
  }
}

resource "nomad_job" "flaubert_drive" {
  jobspec = templatefile("${path.module}/templates/flaubert-drive.nomad.hcl.tpl", {
    datacenter   = var.datacenter
    ecr_registry = var.ecr_registry
    image_tag    = var.image_tag
    drive_port   = var.drive_port
  })

  depends_on = [nomad_variable.drive]
}
