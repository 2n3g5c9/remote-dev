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
    ssh-keys = "${var.ssh_user}:${var.ssh_pub_key}"
  }

  metadata_startup_script = templatefile("${path.module}/startup_script.tpl", { tailscale_key = var.tailscale_key })

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["cloud-platform"]
  }

  tags = ["tailscale-ssh-access"]

  labels = {
    managed-by = "terraform"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE NETWORK RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

resource "google_compute_firewall" "tailscale_ssh" {
  name    = "tailscale-ssh"
  network = "default"

  source_ranges = var.tailscale_machines
  target_tags   = ["tailscale-ssh-access"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
    ports    = ["60000-61000"]
  }
}

resource "google_compute_address" "static_external" {
  name        = "static-external"
  description = "Static external IP address for the remote development server."

  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}
