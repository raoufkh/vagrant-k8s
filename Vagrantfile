# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = '{{Provider}}'

Vagrant.configure("2") do |config|

  config.vm.define "master" do |master|
    master.vm.box = "generic/ubuntu2110"
    master.vm.hostname = "master"
    master.vm.provision "shell", path: "install-containerd.sh", privileged: false
    master.vm.provision "shell", path: "install-helm.sh", privileged: false
    master.vm.provision "shell", path: "install-kubeadm-kubelet-kubectl.sh", privileged: false
    master.vm.provision "shell", path: "install-helm.sh", privileged: false
    master.vm.provision "shell", path: "prepare-nodes.sh", privileged: false
    master.vm.provision :reload
    master.vm.provision "shell", path: "setup-master-node.sh", privileged: false
    master.vm.provider "{{Provider}}" do |p|
      p.memory = {{MasterMemory}}
      p.cpus= {{MasterCPU}}
    end
  end

  WorkerCount = {{WorkerCount}}

  (1..WorkerCount).each do |i|
    config.vm.define "worker#{i}" do |worker|
      worker.vm.box = "generic/ubuntu2110"
      worker.vm.hostname = "worker#{i}"
      worker.vm.network "private_network", ip: "10.100.100.3#{i}"
      worker.vm.provision "shell", path: "install-containerd.sh", privileged: false
      worker.vm.provision "shell", path: "install-kubeadm-kubelet-kubectl.sh", privileged: false
      worker.vm.provision "shell", path: "install-helm.sh", privileged: false
      worker.vm.provision "shell", path: "prepare-nodes.sh", privileged: false
      worker.vm.provision :reload
      worker.vm.provider "{{Provider}}" do |p|
        p.memory = {{WorkerMemory}}
        p.cpus= {{WorkerCPU}}
      end
    end  
  end

end

