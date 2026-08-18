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
        image = "${ecr_registry}deleuze-db:16-alpine"
        ports = ["db"]
        args  = ["-c", "log_statement=all"]
      }

      env {
        POSTGRES_USER     = "${db_user}"
        POSTGRES_PASSWORD = "${db_password}"
        POSTGRES_DB       = "${auth_db_name}"
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
        image = "871950640338.dkr.ecr.ap-northeast-1.amazonaws.com/deleuze-db:latest"
        ports = ["db"]
        args  = ["-c", "log_statement=all"]
      }

      env {
        POSTGRES_USER     = "${db_user}"
        POSTGRES_PASSWORD = "${db_password}"
        POSTGRES_DB       = "${app_db_name}"
      }
    }
  }
}