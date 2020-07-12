locals {
  environment = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
}

data "terraform_remote_state" "projecta" {
  backend = "gcs"
  config = {
    bucket  = "huy-tf-state"
  }
  workspace = terraform.workspace
}

resource "google_project_iam_member" "project" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${data.terraform_remote_state.projecta.outputs.service_account_email}"
}

