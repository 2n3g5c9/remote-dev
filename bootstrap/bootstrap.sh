#!/usr/bin/env bash

set -eu

export DEBIAN_FRONTEND=noninteractive

apt-sources() {
    echo " ==> Adds additional APT sources"
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/jammy.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
}

apt-upgrade() {
    echo " ==> Upgrading packages"
    sudo apt-get update && sudo apt-get upgrade -y
    sudo apt-get auto-remove -y
}

apt-installs() {
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections

    echo " ==> Installing base packages"
    sudo apt-get update
    sudo apt-get install -y \
        iptables-persistent \
        mosh \
        sshguard \
        tailscale \
        xdg-utils
    sudo apt-get auto-remove -y
}

ops-agent-install() {
    echo " ==> Installing Ops Agent"
    curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
    sudo bash add-google-cloud-ops-agent-repo.sh --also-install
}

security-hardening() {
    echo " ==> Setting up sshd"
    sudo cp config/ssh/sshd_config /etc/ssh/sshd_config
    sudo sed -i "s/SSH_USERNAME/${SSH_USERNAME}/g" /etc/ssh/sshd_config

    echo " ==> Setting up sshguard"
    sudo iptables -N sshguard
    sudo iptables -A INPUT -m multiport -p tcp --destination-ports 22 -j sshguard
    sudo iptables -A INPUT -m multiport -p udp --destination-ports 60000:61000 -j sshguard
    sudo mkdir -p /etc/iptables
    sudo sh -c "iptables-save > /etc/iptables/rules.v4"
    sudo sh -c "iptables-save > /etc/iptables/rules.v6"
}

set-dotfiles(){
    echo "[data]
        email = \"marc.m@outlook.com\"
        name = \"Marc Molina\"" >> "${HOME}"/.config/chezmoi/chezmoi.toml
    sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply 2n3g5c9
}

do-it() {
    # Add APT sources.
    apt-sources

    # Update package index and upgrade packages.
    apt-upgrade

    # APT installs.
    apt-installs

    # Install Ops Agent.
    # Disabled until available for Ubuntu 22.04.
    # ops-agent-install

    # Security hardening.
    security-hardening

    # Set dotfiles.
    set-dotfiles
}

do-it

}