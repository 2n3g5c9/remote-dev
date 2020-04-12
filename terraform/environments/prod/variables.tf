variable "project" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "machine_type" {
  type    = string
}

variable "gce_ssh_user" {
  type    = string
}

variable "gce_ssh_pub_key_file" {
  type    = string
}
