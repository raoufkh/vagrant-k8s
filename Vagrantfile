# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'libvirt'

Vagrant.configure("2") do |config|

  config.vm.define "master" do |master|
    master.vm.box = "generic/ubuntu1804"
    master.vm.hostname = "master"
    #master.vm.network "private_network", ip: "10.20.50.10"
    master.vm.provision "shell", path: "install-docker.sh", privileged: false
    master.vm.provision "shell", path: "install-helm.sh", privileged: false
    master.vm.provision "shell", path: "install-kubeadm-kubelet-kubectl.sh", privileged: false
    master.vm.provision "shell", path: "prepare-nodes.sh", privileged: false
    master.vm.provision "shell", path: "install-helm.sh", privileged: false
    master.vm.provision "shell", path: "setup-master-node.sh", privileged: false
    master.vm.provider "libvirt" do |lv|
      lv.memory = 6000
      lv.cpus= 5
    end
  end

  WorkerCount = 3

  (1..WorkerCount).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "generic/ubuntu1804"
      worker.vm.hostname = "worker#{i}"
      #worker.vm.network "private_network", ip: "10.20.50.1#{i}"
      worker.vm.provision "shell", path: "install-docker.sh", privileged: false
      worker.vm.provision "shell", path: "install-kubeadm-kubelet-kubectl.sh", privileged: false
      worker.vm.provision "shell", path: "prepare-nodes.sh", privileged: false
      worker.vm.provider "libvirt" do |lv|
        lv.memory = 9000
        lv.cpus= 9
      end
    end  
  end

end

