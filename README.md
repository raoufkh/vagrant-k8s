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

## Prepare the config file
Put your custom values in the config file fields:

| Parameter | Description | Default value |
| --- | --- | --- |
| `provider` | Vagrant provider name. | `libvirt` |
| `topology.workers_count` | Number of k8s workers. | `2` |
| `topology.master.memory` | Memory allocated to the master in bytes. | `2000` |
| `topology.master.cpu` | CPU allocated to the master. | `2` |
| `topology.worker.memory` | Memory allocated to each worker in bytes. | `2000` |
| `topology.worker.cpu` | CPU allocated to each worker. | `2` |

## Run the script
```
python main.py -c config.yaml
```

## Check the status of created VMS
```
sudo vagrant status
```

## Check that the k8s cluster was created
Finally, you can access the k8s master using the command `sudo vagrant ssh master`, and then run:
```
kubectl get nodes
```
