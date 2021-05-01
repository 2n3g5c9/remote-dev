# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "gce_ssh_pub_key_file" {
  type = string
}

variable "gce_ssh_user" {
  type = string
}

variable "machine_type" {
  type = string

  validation {
    condition = (
      can(regex("[[:alnum:]]+-[[:lower:]]+(?:-[[:digit:]]){0,1}", var.machine_type))
    )
    error_message = "The machine type doesn't have a proper format."
  }
}

variable "project" {
  type = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ---------------------------------------------------------------------------------------------------------------------

variable "region" {
  type    = string
  default = "europe-west1"

  validation {
    condition = (
      can(regex("[[:lower:]]+-[[:lower:]]+[[:digit:]]", var.region))
    )
    error_message = "The region value doesn't have a proper format."
  }
}

variable "zone" {
  type    = string
  default = "europe-west1-b"

  validation {
    condition = (
      can(regex("[[:lower:]]+-[[:lower:]]+[[:digit:]]-[[:lower:]]", var.zone))
    )
    error_message = "The zone value doesn't have a proper format."
  }
}
