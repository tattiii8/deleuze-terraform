job "deleuze-gateway" {
  datacenters = ["dc1"]
  type        = "service"

  group "gateway" {
    count = 1

    network {
      port "http" {
        static = 8888
        to     = 80
      }
    }

    # 1. Cloudflare Tunnel タスク
    task "cloudflared" {
      driver = "docker"

      config {
        image = "871950640338.dkr.ecr.ap-northeast-1.amazonaws.com/cloudflare/cloudflared:latest"
        args  = [
          "tunnel",
          "--no-autoupdate",
          "run"
        ]
      }

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/deleuze-gateway" }}
TUNNEL_TOKEN="{{ .CLOUDFLARE_TUNNEL_TOKEN }}"
{{ end }}
EOF
        destination = "secrets/env"
        env         = true
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    # 2. Nginx リバースプロキシ タスク
    task "nginx" {
      driver = "docker"

      config {
        image = "871950640338.dkr.ecr.ap-northeast-1.amazonaws.com/nginx:alpine"
        ports = ["http"]

        volumes = [
          "local/default.conf:/etc/nginx/conf.d/default.conf"
        ]
      }

      template {
        data = <<EOF
{{ with nomadVar "nomad/jobs/deleuze-gateway" }}
server {
    listen 80;
    server_name _;

    client_max_body_size 500M;

    real_ip_header CF-Connecting-IP;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    # proxy_pass の末尾スラッシュを削除し、プレフィックスパスを維持してバックエンドへ転送
    location /api/auth/ {
        proxy_pass http://{{ .HOST_IP }}:{{ .AUTH_PORT }};
    }

    location /api/app/ {
        proxy_pass http://{{ .HOST_IP }}:{{ .APP_PORT }};
    }

    location /api/mng/ {
        proxy_pass http://{{ .HOST_IP }}:{{ .MNG_PORT }};
    }

    location /api/drive/ {
        proxy_pass http://{{ .HOST_IP }}:{{ .DRIVE_PORT }};
    }
}
{{ end }}
EOF
        destination = "local/default.conf"
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }
  }
}