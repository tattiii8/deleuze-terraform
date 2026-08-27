job "flaubert-db" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "flaubert-drive" {
    count = 1

    network {
      mode = "bridge"

      port "db" {
        static = ${drive_db_port}
        to     = 5432
      }
    }

    task "flaubert-drive" {
      driver = "docker"

      config {
        image = "${ecr_registry}/flaubert-db:16-alpine"
        ports = ["db"]
        args  = ["-c", "log_statement=all"]
      }

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/flaubert-drive-db" }}
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

