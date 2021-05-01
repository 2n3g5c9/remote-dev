terraform {
  required_version = ">= 0.15, < 0.16"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.0"
    }
  }
}