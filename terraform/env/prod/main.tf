locals {
  env = "prod"
}

provider "google" {
  project = var.project
  region  = var.region
}

# ------------------------------------------------------------------------------
# CREATE DEVELOPMENT INSTANCE
# ------------------------------------------------------------------------------

module "remote_dev" {
  source = "../../modules/remote-dev"

  project      = var.project
  machine_type = var.machine_type

  ssh_user    = var.ssh_user
  ssh_pub_key = var.ssh_pub_key

  tailscale_key      = var.tailscale_key
  tailscale_machines = var.tailscale_machines
}
