job "deleuze-drive" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "api" {
    count = 1

    network {
      port "http" { static = ${drive_port} }
    }

    task "deleuze-drive" {
      driver = "docker"

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