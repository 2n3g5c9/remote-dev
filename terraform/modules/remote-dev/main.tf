# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A DEVELOPMENT INSTANCE ACCESSIBLE VIA SSH AND MOSH OVER THE INTERNET
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# CREATE DEVELOPMENT INSTANCE
# ---------------------------------------------------------------------------------------------------------------------

data "google_compute_default_service_account" "default" {}

data "google_compute_image" "this" {
  family  = "remote-dev"
  project = var.project
}

resource "google_compute_instance" "this" {
  name         = "remote-dev"
  machine_type = var.machine_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = data.google_compute_image.this.name
    }
  }

  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static_external.address
    }
  }

  allow_stopping_for_update = true

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${var.gce_ssh_pub_key}"
  }

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  tags = ["public-ssh-access"]

  labels = {
    managed-by = "terraform"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE NETWORK RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "public_ssh" {
  name    = "public-ssh"
  network = "default"

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["public-ssh-access"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
    ports    = ["60000-60010"]
  }
}

resource "google_compute_address" "static_external" {
  name         = "static-external"
  description  = "Static external IP address for the remote development server."
  address_type = "EXTERNAL"
}
