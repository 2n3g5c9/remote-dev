# ------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ------------------------------------------------------------------------------

variable "gcp_project_id" {
  type = string
}

# ------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These variables have defaults, but may be overridden by the operator.
# ------------------------------------------------------------------------------

variable "gce_source_image_family" {
  type    = string
  default = "ubuntu-2204-lts"
}

variable "gce_source_image_project_id" {
  type    = string
  default = "ubuntu-os-cloud"
}

variable "gce_zone" {
  type    = string
  default = "us-east1-b"
}

variable "name" {
  type    = string
  default = "remote-dev"
}

variable "ssh_username" {
  type    = string
  default = "2n3g5c9"
}

locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }
