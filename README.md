# Terraform Multiple Environments!

Terraform is a tool for provisioning immutable infrastructure. It allows you to create infrastructure programmatically in a declarative manner while tracking the state of the infrastructure. Since I wasn’t really happy with terrform and Deployment Manager is not that mature yet and have to use it cause it already has been selected by my organization :-)), I decided to do some research, copy people ideas and come up with the solution.


## Background

This project had a few simple requirements, specifically that we needed to be able to deploy infrastructure to multiple enviroment such as: 

 - dev
 - qa
 - sit

It also needed to be able to run multiple terraform projects as a separate deployment. To make it simple you will be able to run  **terraform apply**  on **project a**  and **project b** separately but still be able to reference the terraform **outputs** between them without harcoded parameters.

## Solution

The solution will be using terraform **workspace** and **remote state**. 

Terraform workspaces are the successor to Terraform environments. Workspaces allow you to separate your state and infrastructure without changing anything in your code.  In addition, you can use workspace with variables retrieve configurations value for deffirent enviroments. For example: 

```
variable  "workspace_to_environment_map" {
	type = map
	default = {
		dev = "dev"
		qa = "qa"
		sit = "sit"
		prod = "prod"
	}
}
```
Retrive environment form the `main.tf` . Each of these has their own expression to calculate the correct value.
```
locals {
	environment = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
}

resource  "google_storage_bucket"  "demo_bucket" {
	name = "bucket-in-${local.environment}"
	force_destroy = true
}

resource  "google_service_account"  "demo_service_account" {
	account_id = "service-account-in-${local.environment}"
	display_name = "Service Account in ${local.environment} to do something"
}
```
**Note:  It is importance to enforce the use of env value to the resource identifier like bucket and service account above. If you want to be region aware then you can contatinate with region value**

Keeping Terraform state in a remote file is a must. I decided to store my project’s state in GCS since it was quick and easy to set up. Retrieves state data from a Terraform backend. This allows you to use the root-level outputs of one or more Terraform configurations as input data for another configuration. This will allow you to referrece to the ouput between projects

**In project b**

```
data  "terraform_remote_state"  "projecta" {
	backend = "gcs"
	config = {
		bucket = "huy-tf-state" # State of the project a
	}
	workspace = terraform.workspace
}

# Terraform >= 0.12
resource  "google_project_iam_member"  "project" {
	project = var.project_id
	role = "roles/editor"
	member = "serviceAccount:${data.terraform_remote_state.projecta.outputs.service_account_email}"
}
```

That is it for now :-)). Happy codeing !!!
