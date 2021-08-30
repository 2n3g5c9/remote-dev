provider "google" {
  project = var.project
  region  = var.region
}

resource "google_storage_bucket" "logs" {
  name = "${var.project}_logs"

  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  versioning {
    enabled = false
  }

  force_destroy = true

  labels = {
    managed-by = "terraform"
  }
}

resource "google_storage_bucket" "tf_state" {
  name = "${var.project}_tf-state"

  location      = var.region
  storage_class = "STANDARD"

  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }

  logging {
    log_bucket        = google_storage_bucket.logs.name
    log_object_prefix = "${var.project}_tf-state"
  }

  force_destroy = true

  labels = {
    managed-by = "terraform"
  }
}
