# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ------------------------------------------------------------------------------

variable "email" {
  type = string
}

variable "machine_type" {
  type = string

  validation {
    condition = (
      can(regex("[[:alnum:]]+-[[:lower:]]+(?:-[[:digit:]]){0,1}", var.machine_type))
    )
    error_message = "The machine type value doesn't have a proper format."
  }
}

variable "name" {
  type = string
}

variable "ssh_pub_key" {
  type = string
}

variable "ssh_user" {
  type = string
}

variable "tailscale_key" {
  sensitive = true
  type      = string

  validation {
    condition = (
      can(regex("tskey-[[:alnum:]]+", var.tailscale_key))
    )
    error_message = "The Tailscale key must start with 'tskey-'."
  }
}

variable "tailscale_machines" {
  type = list(string)

  validation {
    condition = alltrue([
      for tm in var.tailscale_machines : can(regex("100(?:\\.[[:digit:]]+){3}", tm))
    ])
    error_message = "All IP addresses must be 100.x.y.z addresses."
  }
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ------------------------------------------------------------------------------

variable "project" {
  type    = string
  default = "remote-dev-257323"
}

variable "region" {
  type    = string
  default = "us-east1"

  validation {
    condition = (
      can(regex("[[:lower:]]+-[[:lower:]]+[[:digit:]]", var.region))
    )
    error_message = "The region doesn't have a proper format."
  }
}
