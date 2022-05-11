#!/bin/bash

KUBE_VERSION=1.20.11-00

echo "Install kubeadm, kubelet, kubectl"
sudo apt-get -y update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get -y install kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION
sudo apt-mark hold kubelet kubeadm kubectl
