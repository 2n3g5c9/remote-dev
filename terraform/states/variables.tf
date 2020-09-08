# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# These parameters must be supplied when consuming this module.
# ---------------------------------------------------------------------------------------------------------------------

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
