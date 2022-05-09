#!/usr/bin/env bash

set -eu

export DEBIAN_FRONTEND=noninteractive

apt-sources() {
    echo " ==> Adds additional APT sources"
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.gpg | sudo apt-key add -
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/focal.list | sudo tee /etc/apt/sources.list.d/tailscale.list
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
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

security-hardening() {
    echo " ==> Setting up sshd"
    sudo cp config/ssh/sshd_config /etc/ssh/sshd_config
    sudo sed -i "s/SSH_USERNAME/${SSH_USERNAME}/g" /etc/ssh/sshd_config

    echo " ==> Setting up sshguard"
    sudo iptables -A INPUT -m multiport -p tcp --destination-ports 22 -j sshguard
    sudo iptables -A INPUT -m multiport -p udp --destination-ports 60000:61000 -j sshguard
    sudo mkdir -p /etc/iptables
    sudo sh -c "iptables-save > /etc/iptables/rules.v4"
    sudo sh -c "iptables-save > /etc/iptables/rules.v6"
}

do-it() {
    # Add APT sources.
    apt-sources

    # Update package index and upgrade packages.
    apt-upgrade

    # APT installs.
    apt-installs

    # Security hardening.
    security-hardening
}

do-it
