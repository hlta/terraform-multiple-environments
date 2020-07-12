locals {
  environment = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
}


resource "google_storage_bucket" "demo_bucket" {
  name          = "bucket-in-${local.environment}"
  force_destroy = true
}

resource "google_service_account" "demo_service_account" {
  account_id   = "service-account-in-${local.environment}"
  display_name = "Service Account in ${local.environment} to do something"
}


