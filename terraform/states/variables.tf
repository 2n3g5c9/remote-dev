variable "project" {
  type = string
}

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