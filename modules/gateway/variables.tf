variable "datacenter" { type = string }
variable "ecr_registry" { type = string }
variable "cloudflare_tunnel_token" {
  type      = string
  sensitive = true
}
variable "host_ip" { type = string }
variable "auth_port" { type = number }
variable "mng_port" { type = number }
variable "drive_port" { type = number }
variable "mng_front_port" { type = number }

