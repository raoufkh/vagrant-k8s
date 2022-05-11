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
    filedata = f.read()
    newdata = filedata.replace('{{Provider}}', str(config_dict['provider']))
    newdata = newdata.replace('{{WorkerCount}}', str(config_dict['topology']['workers_count']))
    with open('Vagrantfile', 'w') as f:
        f.write(newdata)

os.system('sudo vagrant up')
    
    