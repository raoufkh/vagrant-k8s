# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
configuration = YAML.load_file('config.yaml')
machines = configuration['machines']

ENV['VAGRANT_NO_PARALLEL'] = 'yes'
ENV['VAGRANT_DEFAULT_PROVIDER'] = configuration['provider']

join_command = nil
master_name= nil

Vagrant.configure("2") do |config|

  machines.each do |m|
    config.vm.define m['name']  do |node|
      # The following will be executed regardless of the node role (master or worker)
      node.vm.box = m['box']
      node.vm.hostname = m['name']
      node.vm.provider configuration['provider'] do |p|
        p.memory = m['memory']
        p.cpus= m['cpu']
      end
      node.vm.provision "shell", path: "install-containerd.sh", privileged: false
      node.vm.provision "shell", path: "install-kubeadm-kubelet-kubectl.sh", privileged: false
      node.vm.provision "shell", path: "install-helm.sh", privileged: false
      node.vm.provision "shell", path: "prepare-nodes.sh", privileged: false
      #node.vm.provision :reload
      # The following depend on the node role
      case m['role']
        when "master"
          master_name = m['name']
          node.vm.provision "shell", path: "setup-master-node.sh", privileged: false
          node.vm.provision "shell", path: "install-addons.sh", privileged: false
          node.vm.network "private_network", ip: m['ip']
          node.trigger.after :up do |trigger|
            trigger.info = "Get the join command"
            trigger.ruby do |env,machine|
              master_name = m['name']
              puts master_name
            end
            #get_token_command = "sudo vagrant ssh " + master_name + " -c 'sudo kubeadm token create --print-join-command'"          
            #output = IO.popen(get_token_command)
            #join_command = "sudo " + output.read
          end
        when "worker"
          #node.vm.network "private_network", type: "dhcp"
          node.vm.network "private_network", ip: m['ip']          
      end
    end
  end

end

