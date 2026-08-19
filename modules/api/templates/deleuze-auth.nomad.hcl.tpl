job "deleuze-auth" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "api" {
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

      template {
        data = <<EOF
                {{ with nomadVar "nomad/jobs/deleuze-auth" }}
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