# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
configuration = YAML.load_file('config.yaml')
machines = configuration['machines']

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = configuration['provider']

Vagrant.configure("2") do |config|

  machines.each do |machine|
    config.vm.define machine['name']  do |guest|
      # The following will be executed regardless of the node role (master or worker)
      guest.vm.box = machine['box']
      guest.vm.hostname = machine['name']
      guest.vm.provider "configuration['provider']" do |p|
        p.memory = machine['memory']
        p.cpus= machine['cpu']
      end
      guest.vm.provision "shell", path: "install-containerd.sh", privileged: false
      guest.vm.provision "shell", path: "install-kubeadm-kubelet-kubectl.sh", privileged: false
      guest.vm.provision "shell", path: "install-helm.sh", privileged: false
      guest.vm.provision "shell", path: "prepare-nodes.sh", privileged: false
      guest.vm.provision :reload
      # The following depend on the node role
      
  end

end

