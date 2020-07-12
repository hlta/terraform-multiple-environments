variable "workspace_to_environment_map" {
  type = map
  default = {
    dev     = "dev"
    qa      = "qa"
    staging = "staging"
    prod    = "prod"
  }
}

variable "project_id" {
    description = "Google Project ID."
    type        = string
    default     = "sandbox-267203"
}

variable "region" {
    description = "Google Cloud region"
    type        = string
    default     = "europe-west2"
}

