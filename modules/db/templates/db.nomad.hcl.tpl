job "deleuze-db" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "deleuze-auth" {
    count = 1

    network {
      mode = "bridge"
      port "db" { static = ${auth_db_port} }
    }

    task "deleuze-auth" {
      driver = "docker"

      config {
        image = "${ecr_registry}/deleuze-db:16-alpine"
        ports = ["db"]
        args  = ["-c", "log_statement=all"]
      }

      # 💡 Nomad Variables から環境変数を取得
      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/deleuze-auth-db" }}
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

  group "deleuze-app" {
    count = 1

    network {
      mode = "bridge"
      port "db" {
        static = ${app_db_port}
        to     = 5432
      }
    }

    task "deleuze-app" {
      driver = "docker"

      config {
        image = "${ecr_registry}/deleuze-db:16-alpine"
        ports = ["db"]
        args  = ["-c", "log_statement=all"]
      }

      # 💡 Nomad Variables から環境変数を取得
      template {
        data = <<EOF
                {{ with nomadVar "nomad/jobs/deleuze-app-db" }}
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