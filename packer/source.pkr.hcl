source "googlecompute" "ubuntu" {
  image_description       = "Ubuntu 22.04 LTS remote development server."
  image_family            = var.name
  image_name              = "packer-${var.name}-${local.timestamp}"
  network                 = "default"
  project_id              = var.gcp_project_id
  scopes                  = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.full_control"
  ]
  source_image_family     = var.gce_source_image_family
  source_image_project_id = [var.gce_source_image_project_id]
  ssh_username            = var.ssh_username
  tags                    = [var.name]
  use_internal_ip         = false
  zone                    = var.gce_zone
}