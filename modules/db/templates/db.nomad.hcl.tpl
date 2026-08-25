job "deleuze-db" {
  datacenters = ["${datacenter}"]
  type        = "service"

  # =========================================================
  # Deleuze Auth DB
  #
  # 認証サービス専用DB
  #
  # 将来的に:
  #   auth_flaubert
  #   auth_balzac
  #   ...
  #
  # を deleuze-auth が管理する。
  # =========================================================
  group "deleuze-auth" {
    count = 1

    network {
      mode = "bridge"

      port "db" {
        static = ${auth_db_port}
      }
    }

    task "deleuze-auth" {
      driver = "docker"

      config {
        image = "${ecr_registry}/deleuze-db:16-alpine"
        ports = ["db"]
        args  = ["-c", "log_statement=all"]
      }

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


  # =========================================================
  # Deleuze Management DB
  #
  # 管理サービス専用DB
  #
  # 将来的に:
  #   public.Tenants
  #   public.Services
  #   public.TenantServices
  #   ...
  #
  # を deleuze-mng が管理する。
  # =========================================================
  group "deleuze-mng" {
    count = 1

    network {
      mode = "bridge"

      port "db" {
        static = ${mng_db_port}
        to     = 5432
      }
    }

    task "deleuze-mng" {
      driver = "docker"

      config {
        image = "${ecr_registry}/deleuze-db:16-alpine"
        ports = ["db"]
        args  = ["-c", "log_statement=all"]
      }

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/deleuze-mng-db" }}
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


  # =========================================================
  # Deleuze Drive DB
  #
  # ファイル管理サービス専用DB
  #
  # 将来的に:
  #   drive_flaubert
  #   drive_balzac
  #   ...
  #
  # を deleuze-drive が管理する。
  # =========================================================
  group "deleuze-drive" {
    count = 1

    network {
      mode = "bridge"

      port "db" {
        static = ${drive_db_port}
        to     = 5432
      }
    }

    task "deleuze-drive" {
      driver = "docker"

      config {
        image = "${ecr_registry}/deleuze-db:16-alpine"
        ports = ["db"]
        args  = ["-c", "log_statement=all"]
      }

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/deleuze-drive-db" }}
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