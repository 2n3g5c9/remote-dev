# ------------------------------------------------------------------------------
# DEPLOY A DEVELOPMENT INSTANCE ACCESSIBLE VIA SSH AND MOSH IN A TAILSCALE NETWORK
# ------------------------------------------------------------------------------

# ------------------------------------------------------------------------------
# CREATE DEVELOPMENT INSTANCE
# ------------------------------------------------------------------------------

data "google_compute_default_service_account" "default" {}

data "google_compute_image" "this" {
  family  = "remote-dev"
  project = var.project
}

#tfsec:ignore:google-compute-vm-disk-encryption-customer-key
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

    #tfsec:ignore:google-compute-no-public-ip
    access_config {
      nat_ip       = google_compute_address.static_external.address
      network_tier = "STANDARD"
    }
  }

  allow_stopping_for_update = true

  shielded_instance_config {
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  metadata = {
    ssh-keys               = "${var.ssh_user}:${var.ssh_pub_key}"
    block-project-ssh-keys = true
  }

  metadata_startup_script = templatefile("${path.module}/startup_script.tpl",
    {
      name  = var.name
      email = var.email

      tailscale_key      = var.tailscale_key
      tailscale_machines = var.tailscale_machines
    }
  )

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["logging-write", "monitoring-write"]
  }

  tags = ["remote-dev"]

  labels = {
    env        = var.env
    managed-by = "terraform"
  }
}

# ------------------------------------------------------------------------------
# CREATE NETWORK RESOURCES
# ------------------------------------------------------------------------------

resource "google_compute_firewall" "ingress" {
  name    = "ingress"
  network = "default"

  direction     = "INGRESS"
  source_ranges = var.tailscale_machines
  target_tags   = ["remote-dev"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  allow {
    protocol = "udp"
    ports    = ["60000-61000"]
  }
}

resource "google_compute_firewall" "egress" {
  name    = "egress"
  network = "default"

  direction          = "EGRESS"
  destination_ranges = ["0.0.0.0/0"] #tfsec:ignore:google-compute-no-public-egress
  target_tags        = ["remote-dev"]

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}

resource "google_compute_address" "static_external" {
  name        = "static-external"
  description = "Static external IP address for the remote development server."

  address_type = "EXTERNAL"
  network_tier = "STANDARD"
}
