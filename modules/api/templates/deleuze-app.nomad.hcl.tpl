job "deleuze-app" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "api" {
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

      template {
        data = <<EOF
                {{ with nomadVar "nomad/jobs/deleuze-app" }}
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