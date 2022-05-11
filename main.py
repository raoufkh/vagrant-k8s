import argparse
import os
import yaml
from yaml.loader import SafeLoader

parser = argparse.ArgumentParser()
parser.add_argument("-c", "--config", help="The path to the config file", default='config.yaml')
args = parser.parse_args()

file_name = args.config
config_file = open(file_name, encoding='utf8', errors='ignore')
config_dict = yaml.load(config_file, Loader=SafeLoader)

with open('Vagrantfile', 'r') as f :
    workers_count = config_dict['topology']['workers_count']
    filedata = f.read()
    newdata = filedata.replace('{{Provider}}', str(config_dict['provider']))
    newdata = newdata.replace('{{WorkerCount}}', str(workers_count))
    with open('Vagrantfile', 'w') as f:
        f.write(newdata)

# Vagrant up
os.system('sudo vagrant up')

# Get the joint command on the master
command = 'sudo vagrant ssh master -c \'sudo kubeadm token create --print-join-command\''
output = os.popen(command)
output_txt = output.read()

# Run the join command on workers
for i in range(1, workers_count+1):
    join_command = 'sudo vagrant ssh worker' + str(i) + ' -c \'' + output_txt + '\''
    os.system(command)

    
    