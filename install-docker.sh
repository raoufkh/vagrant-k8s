#!/bin/bash

DOCKER_VERSION=5:19.03.11~3-0~ubuntu-$(lsb_release -cs)

echo "Setup Docker"

echo "Remove old docker versions"
sudo apt-get remove -qq docker docker-engine docker.io containerd runc

echo "Install Docker"
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
sudo apt-get -y install docker-ce=$DOCKER_VERSION docker-ce-cli=$DOCKER_VERSION containerd.io

echo "Add the vagrant user to the Docker group"
sudo groupadd docker
sudo usermod -aG docker vagrant

echo "Verify Docker that Docker has been installed"
docker --version
