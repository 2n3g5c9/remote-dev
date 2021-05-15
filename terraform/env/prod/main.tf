locals {
  env = "prod2"
}

provider "google" {
  project = var.project
  region  = var.region
}

module "remote_dev" {
  source = "../../modules/remote-dev"

  project      = var.project
  machine_type = var.machine_type

  gce_ssh_user    = var.gce_ssh_user
  gce_ssh_pub_key = var.gce_ssh_pub_key
}
