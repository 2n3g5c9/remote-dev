#!/usr/bin/env bash

# shellcheck disable=SC1083
%{ for tm in tailscale_machines ~}
# shellcheck disable=SC2154
sudo iptables -A INPUT -p tcp -s "${tm}" --dport 22 -j ACCEPT
# shellcheck disable=SC2154
sudo iptables -A INPUT -p udp -s "${tm}" --dport 60000:61000 -j ACCEPT
# shellcheck disable=SC1083
%{ endfor ~}
sudo iptables -A INPUT -p tcp -s 0.0.0.0/0 --dport 22 -j DROP
sudo iptables -A INPUT -p udp -s 0.0.0.0/0 --dport 60000:61000 -j DROP
sudo sh -c "iptables-save > /etc/iptables/rules.v4"
sudo sh -c "iptables-save > /etc/iptables/rules.v6"

# shellcheck disable=SC2154
tailscale up --authkey="${tailscale_key}"
