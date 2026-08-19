job "deleuze-api" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "auth" {
    count = 1

    network {
      port "http" { static = ${auth_port} }
    }

    task "deleuze-auth" {
      driver = "docker"

      config {
        image      = "${ecr_registry}/deleuze-auth:${image_tag}"
        ports      = ["http"]
        force_pull = true
      }

      env {
        ASPNETCORE_ENVIRONMENT = "${aspnetcore_environment}"
        ASPNETCORE_URLS        = "http://+:${auth_port}"
        
        ConnectionStrings__DefaultConnection = "Host=${host_ip};Port=${auth_db_port};Database=${auth_db_name};Username=${db_user};Password=${db_password}"

        AUTH_EXTERNAL_URL = "${auth_external_url}"
        AUTH_INTERNAL_URL = "http://${host_ip}:${auth_port}"
      }
    }
  }

  group "app" {
    count = 1

    network {
      port "http" { static = ${app_port} }
    }

    task "deleuze-app" {
      driver = "docker"

      config {
        image      = "${ecr_registry}/deleuze-app:${image_tag}"
        ports      = ["http"]
        force_pull = true
      }

      env {
        ASPNETCORE_ENVIRONMENT = "${aspnetcore_environment}"
        ASPNETCORE_URLS        = "http://+:${app_port}"

        ConnectionStrings__AppConnection = "Host=${host_ip};Port=${app_db_port};Database=${app_db_name};Username=${db_user};Password=${db_password}"

        AUTH_EXTERNAL_URL = "http://${host_ip}:${auth_port}"
        AUTH_INTERNAL_URL = "http://${host_ip}:${auth_port}"
      }
    }
  }

  group "mng" {
    count = 1

    network {
      port "http" { static = ${mng_port} }
    }

    task "deleuze-mng" {
      driver = "docker"

      config {
        image      = "${ecr_registry}/deleuze-mng:${image_tag}"
        ports      = ["http"]
        force_pull = true
      }

      env {
        ASPNETCORE_ENVIRONMENT = "${aspnetcore_environment}"
        ASPNETCORE_URLS        = "http://+:${mng_port}"
        
        ConnectionStrings__AuthConnection = "Host=${host_ip};Port=${auth_db_port};Database=${auth_db_name};Username=${db_user};Password=${db_password}"
        ConnectionStrings__AppConnection  = "Host=${host_ip};Port=${app_db_port};Database=${app_db_name};Username=${db_user};Password=${db_password}"
        MANAGEMENT_API_SECRET              = "${management_api_secret}"
        ENABLE_MNG_AUTH       = "${enable_mng_auth}"
      }
    }
  }
}