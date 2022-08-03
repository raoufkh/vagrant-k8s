import os
import yaml
from yaml.loader import SafeLoader
from time import sleep

file_name = 'config.yaml'
config_file = open(file_name, encoding='utf8', errors='ignore')
config_dict = yaml.load(config_file, Loader=SafeLoader)

master_init_name = None
workers_list = []
for machine in config_dict['machines']:
    if machine['role'] == 'master-init':
        master_init_name = machine['name']
    elif machine['role'] == 'worker':
        workers_list.append(machine['name'])
    
if not master_init_name:
    print('No node with master-init role found')
    exit()

# Vagrant up
os.system('sudo vagrant up')
print('Vagrant up finished')
sleep(3)

# Reload the master
#os.system('sudo vagrant reload master')
#print('Master reloaded')
#sleep(3)

# Get the join command on the master
print("Getting the join command")
output_txt = ""
command = f"sudo vagrant ssh {master_init_name} -c 'sudo kubeadm token create --print-join-command'"
output = os.popen(command)
sleep(10)
output_txt = output.read()
output_txt = "sudo " + output_txt
print(output_txt)

# Run the join command on workers
for i in range(1, workers_count+1):
for woker_name in workers_list:
    print(f"Joining {woker_name}")
    joint_output_txt = ""
    join_command = f"sudo vagrant ssh {woker_name} -c '" + output_txt + "'"
    joint_output = os.popen(join_command)
    joint_output_txt = joint_output.read()
    print(joint_output_txt)
    
    