#!/bin/bash

echo "Setup Containerd"

echo "Install Dependencies"
sudo apt-get update
sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get -y install containerd.io

echo "Check containerd version"
containerd --version

echo "Configure containerd"
sudo bash -c "containerd config default > /etc/containerd/config.toml"
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml

echo "Restart containerd"
sudo systemctl restart containerd

echo "Configure containerd to run at startup"
sudo systemctl enable containerd








