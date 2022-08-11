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
      #node.vm.provision :reload
      # The following depend on the node role
      case machine['role']
        when "master"
          master_name = machine['name']
          node.vm.provision "shell", path: "setup-master-node.sh", privileged: false
          node.vm.provision "shell", path: "install-addons.sh", privileged: false
          node.vm.network "private_network", ip: machine['ip']
        when "worker"
          #node.vm.network "private_network", type: "dhcp"
          node.vm.network "private_network", ip: machine['ip']          
      end
    end
  end

end

### Join nodes
# Get the join_command            
get_token_command = "sudo vagrant ssh " + master_name + " -c 'sudo kubeadm token create --print-join-command'"          
output = IO.popen(get_token_command)
join_command = "sudo " + output.read
# Join worker nodes
machines.each do |machine|
  case machine['role']
    when "worker"
      # Join the worker to the cluster
      #node.vm.provision "shell", inline: join_command, privileged: false
      woker_name = machine['name']
      worker_join_command = "sudo vagrant ssh " + woker_name + " -c '" + join_command + "'"
      system(worker_join_command)
  end
end


