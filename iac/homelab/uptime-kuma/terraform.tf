terraform {
  # Environment-specific backend configuration belongs here when remote state
  # is introduced. Version constraints live in the reusable module.
  required_providers {
    uptimekuma = {
      source = "ehealth-co-id/uptimekuma"
    }
  }
}
