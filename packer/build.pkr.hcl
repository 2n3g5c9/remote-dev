build {
  sources = ["source.googlecompute.ubuntu"]

  provisioner "shell" {
    environment_vars = ["SSH_USERNAME=${var.ssh_username}"]
    inline           = [
      "git clone https://github.com/2n3g5c9/remote-dev.git /tmp/remote-dev",
      "(cd /tmp/remote-dev/bootstrap; ./bootstrap.sh)"
    ]
  }
}