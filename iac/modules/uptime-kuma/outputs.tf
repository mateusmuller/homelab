output "infrastructure" {
  description = "Uptime Kuma monitors managed by this module."
  value = {
    monitors = {
      for monitor_key, monitor in uptimekuma_monitor.this : monitor_key => {
        id       = monitor.id
        name     = monitor.name
        type     = monitor.type
        active   = monitor.active
        url      = monitor.url
        hostname = monitor.hostname
        port     = monitor.port
      }
    }
  }
}
