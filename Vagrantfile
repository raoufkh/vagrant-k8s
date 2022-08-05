# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
configuration = YAML.load_file('config.yaml')
machines = configuration['machines']

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = configuration['provider']

Vagrant.configure("2") do |config|

  machines.each do |machine|
    config.vm.define machine['name']  do |machine|
      # The following will be executed regardless of the node role (master or worker)
      machine.vm.box = machine['box']
      machine.vm.hostname = machine['name']
      machine.vm.provider "configuration['provider']" do |p|
        p.memory = machine['memory']
        p.cpus= machine['cpu']
      machine.vm.provision "shell", path: "install-containerd.sh", privileged: false
      machine.vm.provision "shell", path: "install-kubeadm-kubelet-kubectl.sh", privileged: false
      machine.vm.provision "shell", path: "install-helm.sh", privileged: false
      machine.vm.provision "shell", path: "prepare-nodes.sh", privileged: false
      machine.vm.provision :reload
      # The following depend on the node role
      case machine['role']
        when "master"
          machine.vm.provision "shell", path: "setup-master-node.sh", privileged: false
          machine.vm.provision "shell", path: "install-addons.sh", privileged: false
          machine.vm.network "private_network", ip: machine['ip']
        when "worker"
          machine.vm.network "private_network", type: "dhcp"
      end
  end

end

