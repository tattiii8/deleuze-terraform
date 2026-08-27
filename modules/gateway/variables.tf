variable "datacenter" { type = string }
variable "ecr_registry" { type = string }
variable "cloudflare_tunnel_token" {
  type      = string
  sensitive = true
}
variable "host_ip" { type = string }
variable "drive_port" { type = number }
