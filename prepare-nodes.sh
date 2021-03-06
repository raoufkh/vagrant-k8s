#!/bin/bash

echo "Prepare nodes"

echo "Disable firewall"
sudo ufw disable

echo "Turn swapp off"
sudo swapoff -a 
sudo sed -i  '/swap/ s/^/#/g' /etc/fstab

echo "Set networking rules"
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system


