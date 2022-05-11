#!/bin/bash

echo "Prepare nodes"

echo "Disable firewall"
sudo ufw disable

echo "Turn swapp off"
sudo swapoff -a 
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

