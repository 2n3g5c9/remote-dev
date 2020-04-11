variable "project_name" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-a"
}

variable "machine_type" {
  type    = string
  default = "f1-micro"
}

variable "gce_ssh_user" {
  type    = string
  default = "2n3g5c9"
}

variable "gce_ssh_pub_key_file" {
  type    = string
  default = "ssh/id_rsa.pub"
}
