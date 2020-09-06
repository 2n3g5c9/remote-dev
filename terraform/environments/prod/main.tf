locals {
  env = "prod"
}

provider "google" {
  project = var.project
  region  = var.region
  version = "~> 3.0"
}

module "dev_instance" {
  source = "../../modules/dev-instance"

  project              = var.project
  machine_type         = var.machine_type
  gce_ssh_user         = var.gce_ssh_user
  gce_ssh_pub_key_file = var.gce_ssh_pub_key_file
}