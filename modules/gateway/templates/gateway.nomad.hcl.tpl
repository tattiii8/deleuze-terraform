job "deleuze-gateway" {
  datacenters = ["${datacenter}"]
  type        = "service"

  group "ingress-group" {
    count = 1

    network {
      port "http" {
        to = 80
      }
    }

    task "cloudflared" {
      driver = "docker"

      config {
        image = "${ecr_registry}/cloudflare/cloudflared:latest"
        args  = [
          "tunnel",
          "--no-autoupdate",
          "run",
          "--token", "${cloudflare_tunnel_token}"
        ]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "${ecr_registry}/nginx:alpine"
        ports = ["http"]

        volumes = [
          "local/default.conf:/etc/nginx/conf.d/default.conf"
        ]
      }

      template {
        data = <<EOF
server {
    listen 80;
    server_name _;

    real_ip_header CF-Connecting-IP;

    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;

    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    location /api/auth/ {
        proxy_pass http://${host_ip}:${auth_port}/;
    }

    location /api/app/ {
        proxy_pass http://${host_ip}:${app_port}/;
    }

    location /api/mng/ {
        proxy_pass http://${host_ip}:${mng_port}/;
    }
}
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