job "deleuze-mng" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "api" {
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

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/deleuze-mng" }}
{{ range $k, $v := . }}
{{ $k }}="{{ $v }}"
{{ end }}
{{ end }}
# 💡 Drive サービスの内部プロビジョニング用 URL を追加
Services__Drive__InternalApiUrl="http://{{ env "attr.unique.network.ip-address" }}:${drive_port}"
EOF
        destination = "secrets/env"
        env         = true
      }
    }
  }
}