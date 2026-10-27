variable "uptime_kuma_base_url" {
  description = "Base URL of the Uptime Kuma instance"
  type        = string
}

variable "uptime_kuma_username" {
  description = "Username for the Uptime Kuma administrator account"
  type        = string
  default     = "admin"
}

variable "uptime_kuma_password" {
  description = "Password for the Uptime Kuma administrator account"
  type        = string
  sensitive   = true
}

provider "uptimekuma" {
  base_url = var.uptime_kuma_base_url
  username = var.uptime_kuma_username
  password = var.uptime_kuma_password
}

module "uptime_kuma" {
  source = "../../modules/uptime-kuma"
}

moved {
  from = module.blackbox_monitoring
  to   = module.uptime_kuma
}
