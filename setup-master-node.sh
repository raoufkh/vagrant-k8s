#!/bin/bash

echo "Initialize the master node"
sudo swapoff -a
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

echo "Initialize the master node"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

echo "Deploy a Pod network (flannel) to the cluster"
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


