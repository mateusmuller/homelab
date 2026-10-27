resource "uptimekuma_monitor" "this" {
  for_each = local.monitors

  name                  = each.value.name
  type                  = each.value.type
  active                = each.value.active
  url                   = each.value.url
  method                = each.value.method
  hostname              = each.value.hostname
  port                  = each.value.port
  interval              = each.value.interval
  retry_interval        = each.value.retry_interval
  resend_interval       = each.value.resend_interval
  max_retries           = each.value.max_retries
  upside_down           = each.value.upside_down
  ignore_tls            = each.value.ignore_tls
  max_redirects         = each.value.max_redirects
  body                  = each.value.body
  headers               = length(each.value.headers) > 0 ? jsonencode(each.value.headers) : null
  keyword               = each.value.keyword
  notification_id_list  = each.value.notification_id_list
  accepted_status_codes = each.value.accepted_status_codes
  tags                  = each.value.tags
}
