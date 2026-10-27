terraform {
  required_version = "~> 1.16.4"

  required_providers {
    uptimekuma = {
      source  = "ehealth-co-id/uptimekuma"
      version = "~> 1.0.4"
    }
  }
}
