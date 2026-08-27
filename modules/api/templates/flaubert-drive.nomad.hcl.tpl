job "flaubert-drive" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "api" {
    count = 1

    network {
      port "http" { static = ${drive_port} }
    }

    task "flaubert-drive" {
      driver = "docker"

      config {
        image      = "${ecr_registry}/flaubert-drive:${image_tag}"
        ports      = ["http"]
        force_pull = true
      }

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/flaubert-drive" }}
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
