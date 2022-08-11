# vagrant-k8s

## Install vagrant
```
sudo apt update
sudo apt install vagrant
```

## Install vagrant reload plugin
```
vagrant plugin install vagrant-reload
```

## Configuration
Put your custom values in the config file fields:

| Parameter | Description | Default value |
| --- | --- | --- |
| `provider` | Vagrant provider name. | `libvirt` |
| `machines` | A list of [machine](#machine)s Kubernetes nodes. | `see [config.yaml](./config.yaml)` |

### machine
Each machine element corresponds to a Kubernetes node and consists of:
| Parameter | Description |
| --- | --- |
| `role` | The role of this node (possible values are master or worker). |
| `name` | The name of this node. |
| `box` | The Vagrant box to be used (e.g. generic/ubuntu2010). |
| `memory` | Amount of memory to be assigned to this node (in bytes). |
| `cpu` | Number of CPUs to be assigned to this node. |
| `ip` | IP address to an eth1 interface be on this node. |

## Create the cluster
```
sudo vagrant up
```

## Check the status of created VMS
```
sudo vagrant status
```

## Check that the k8s cluster was created
```
sudo vagrant ssh master -c 'kubectl get nodes'
```
