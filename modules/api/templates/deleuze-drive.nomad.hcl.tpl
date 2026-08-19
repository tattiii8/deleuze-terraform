job "deleuze-drive" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "api" {
    count = 1

    network {
      port "http" { static = ${drive_port} }
    }

    volume "drive-data" {
      type      = "host"
      read_only = false
      source    = "deleuze-drive"
    }

    task "deleuze-drive" {
      driver = "docker"

      volume_mount {
        volume      = "drive-data"
        destination = "/app/uploads"
        read_only   = false
      }

      config {
        image      = "${ecr_registry}/deleuze-drive:${image_tag}"
        ports      = ["http"]
        force_pull = true
      }

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/deleuze-drive" }}
{{ range $k, $v := . }}
{{ $k }}="{{ $v }}"
{{ end }}
{{ end }}
EOF
        destination = "secrets/env"
        env         = true
      }
    }
  }
}