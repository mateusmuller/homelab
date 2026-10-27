locals {
  defaults = yamldecode(file("${path.module}/defaults.yml"))

  config_files = setunion(
    fileset(path.root, "config/**/*.yml"),
    fileset(path.root, "config/**/*.yaml")
  )

  raw_monitors = {
    for config_file in local.config_files :
    trimsuffix(trimsuffix(trimprefix(config_file, "config/"), ".yml"), ".yaml") =>
    yamldecode(file("${path.root}/${config_file}"))
  }

  monitors = {
    for monitor_key, config in local.raw_monitors : monitor_key => merge(
      local.defaults.monitor,
      config,
      {
        name    = try(coalesce(config.name, title(replace(basename(monitor_key), "_", " "))), title(replace(basename(monitor_key), "_", " ")))
        headers = try(config.headers, local.defaults.monitor.headers)
        tags    = try(config.tags, local.defaults.monitor.tags)
      }
    )
  }
}

check "config_files" {
  assert {
    condition     = length(local.config_files) > 0
    error_message = "No monitor configuration found below ${path.root}/config."
  }
}

check "monitor_names" {
  assert {
    condition = alltrue([
      for monitor in values(local.monitors) : try(trimspace(monitor.name) != "", false)
      ]) && length(distinct([
        for monitor in values(local.monitors) : monitor.name
    ])) == length(local.monitors)
    error_message = "Every monitor must have a non-empty, unique name. Names default to their YAML filenames."
  }
}

check "monitor_types" {
  assert {
    condition = alltrue([
      for monitor in values(local.monitors) : contains(["http", "keyword", "ping", "port"], monitor.type)
    ])
    error_message = "Monitor type must be one of the types implemented by provider v1.0.4: http, keyword, ping, or port."
  }
}

check "monitor_targets" {
  assert {
    condition = alltrue([
      for monitor in values(local.monitors) :
      contains(["http", "keyword"], monitor.type) ? try(trimspace(monitor.url) != "", false) :
      contains(["ping", "port"], monitor.type) ? try(trimspace(monitor.hostname) != "", false) :
      false
    ])
    error_message = "HTTP and keyword monitors require url; ping and port monitors require hostname."
  }
}

check "monitor_specific_values" {
  assert {
    condition = alltrue([
      for monitor in values(local.monitors) : alltrue([
        monitor.type != "port" || try(monitor.port >= 1 && monitor.port <= 65535, false),
        monitor.type != "keyword" || try(trimspace(monitor.keyword) != "", false),
        try(monitor.interval > 0, false),
        try(monitor.retry_interval > 0, false),
        try(monitor.max_retries >= 0, false),
      ])
    ])
    error_message = "Port monitors require port 1-65535, keyword monitors require keyword, and timing/retry values must be valid."
  }
}
