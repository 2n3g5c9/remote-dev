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

# ------------------------------------------------------------------------------
# CREATE AGENT POLICY FOR OPS AGENT
# ------------------------------------------------------------------------------

module "agent_policy" {
  source     = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version    = "~> 0.1.0"

  project_id = var.project
  policy_id  = "ops-agents-policy"
  agent_rules = [
    {
      type               = "ops-agent"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  group_labels = [
    {
      env = "prod"
    }
  ]
  os_types = [
    {
      short_name = "ubuntu"
    },
  ]
}