# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
configuration = YAML.load_file('config.yaml')
machines = configuration['machines']

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = configuration['provider']

join_command = nil

Vagrant.configure("2") do |config|

  machines.each do |machine|
    config.vm.define machine['name']  do |node|
      # The following will be executed regardless of the node role (master or worker)
      node.vm.box = machine['box']
      node.vm.hostname = machine['name']
      node.vm.provider configuration['provider'] do |p|
        p.memory = machine['memory']
        p.cpus= machine['cpu']
      end
      node.vm.provision "shell", path: "install-containerd.sh", privileged: false
      node.vm.provision "shell", path: "install-kubeadm-kubelet-kubectl.sh", privileged: false
      node.vm.provision "shell", path: "install-helm.sh", privileged: false
      node.vm.provision "shell", path: "prepare-nodes.sh", privileged: false
      node.vm.provision :reload
      # The following depend on the node role
      case machine['role']
        when "master"
          node.vm.provision "shell", path: "setup-master-node.sh", privileged: false
          node.vm.provision "shell", path: "install-addons.sh", privileged: false
          node.vm.network "private_network", ip: machine['ip']
          # Get the join_command
          master_name = machine['name']
          get_token_command = "sudo vagrant ssh " + master_name + " -c 'sudo kubeadm token create --print-join-command'"
          output = IO.popen(get_token_command)
          join_command = "sudo " + r.read
        when "worker"
          #node.vm.network "private_network", type: "dhcp"
          node.vm.network "private_network", ip: machine['ip']          
          # Join the worker to the cluster
          woker_name = machine['name']
          worker_join_command = "sudo vagrant ssh " + woker_name + " -c '" + join_command + "'"
          system(worker_join_command)
      end
    end
  end

end

