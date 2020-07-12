locals {
  environment = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
}

resource "aws_s3_bucket" "demo_bucket" {

  bucket_prefix = "bucket-in-${var.region}-stage-${local.environment}"

  versioning {
    enabled = true
  }
}

resource "google_service_account" "demo_service_account" {
  account_id   = "service-account-in-${local.environment}"
  display_name = "Service Account in ${local.environment} to do something"
}


