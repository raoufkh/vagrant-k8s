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
      node.vm.provision "shell", inline: "crontab -l | echo '0 * * * * sync; echo 3 > /proc/sys/vm/drop_caches' | crontab -", privileged: true
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
          # Get the join_command
          node.trigger.after :up do |trigger|
            trigger.info = "Get the join command"
            trigger.ruby do |env,machine|
              get_token_command = "vagrant ssh " + master_name + " -c 'sudo kubeadm token create --print-join-command'"
              output = IO.popen(get_token_command)
              join_command = "sudo #{output.read}"
              join_command = join_command.strip
              puts join_command
            end
          end
        when "worker"
          worker_name = m['name']
          node.vm.provision "shell", inline: "cd ~ && mkdir kubedata && mkdir prometheus_data", privileged: false
          #node.vm.network "private_network", type: "dhcp"
          node.vm.network "private_network", ip: m['ip']
          # Join the worker to the cluster
          node.trigger.after :up do |trigger|
            trigger.info = "Join #{worker_name}"
            trigger.ruby do |env,machine|
              worker_join_command = "vagrant ssh #{worker_name} -c '#{join_command}'"
              puts worker_join_command
              system(worker_join_command)
            end
            #trigger.run_remote = {inline: "#{join_command}"}
          end
        when "client"
          client_name = m['name']
          node.vm.network "private_network", ip: m['ip']
          node.vm.provision "shell", path: "compile-ueransim.sh", privileged: false
      end
    end
  end
end
