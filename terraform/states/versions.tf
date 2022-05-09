terraform {
  required_version = ">= 1.1.0, < 1.2.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}
