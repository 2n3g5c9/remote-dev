# Backend configuration

terraform {
  required_version = ">= 0.12, < 0.13"

  backend "gcs" {
    prefix  = "terraform/state"
  }
}

provider "google" {
  project     = var.project-name
  region      = var.region
}

data "google_compute_image" "remote-dev-image" {
  family  = "remote-dev"
  project = var.project-name
}

# Instance configuration

resource "google_compute_instance" "remote-dev" {
  name         = "remote-dev"
  machine_type = var.machine-type
  zone         = var.zone 

  boot_disk {
    initialize_params {
      image = data.google_compute_image.remote-dev-image.name
    }
  }

  network_interface {
    network = google_compute_network.public.name
  
    access_config {
      nat_ip = google_compute_address.static_external.address
    }
  }

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file("${path.module}/${var.gce_ssh_pub_key_file}")}"
  }

  tags = ["public-ssh-access"]
}

# Network configuration

resource "google_compute_network" "public" {
  name = "public"
  description = "Public-facing network."

  routing_mode = "REGIONAL"
}

resource "google_compute_subnetwork" "public" {
    name          = "public-subnetwork"
    region        = var.region 
    
    network       = google_compute_network.public.self_link
    ip_cidr_range = "10.0.0.0/24"
}

resource "google_compute_firewall" "public_ssh" {
  name    = "public-ssh"
  network = google_compute_network.public.name

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["public-ssh-access"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_address" "static_external" {
  name = "static-external"
  description = "Static external IP address for the remote development server."
  address_type = "EXTERNAL"
}
