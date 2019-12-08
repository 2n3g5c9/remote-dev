terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "google" {
  project = var.project-name
  region  = var.region
}

resource "google_storage_bucket" "logs" {
  name = "${var.project-name}_logs"

  location      = var.location
  storage_class = "STANDARD"

  versioning {
    enabled = false
  }

  force_destroy = true

  labels = {
    managed-by = "terraform"
  }
}

resource "google_storage_bucket" "tf-state" {
  name = "${var.project-name}_tf-state"

  location      = var.location
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }

  logging {
    log_bucket        = google_storage_bucket.logs.name
    log_object_prefix = "${var.project-name}_tf-state"
  }

  force_destroy = true

  labels = {
    managed-by = "terraform"
  }
}
