#!/usr/bin/python3

import json
import pyjq
import yaml

import sys

import collections
from copy import deepcopy


def merge(dict1, dict2):
    ''' Return a new dictionary by merging two dictionaries recursively. '''

    result = deepcopy(dict1)

    for key, value in dict2.items():
        if isinstance(value, collections.Mapping):
            result[key] = merge(result.get(key, {}), value)
        else:
            result[key] = deepcopy(dict2[key])

    return result

ClusterYAMLFile = r'/apps/slurm/scripts/cluster.yaml'

with open(ClusterYAMLFile) as file:
    ClusterConfig = yaml.load(file, Loader=yaml.FullLoader)

ControllerConfig = pyjq.all('.[].Controller',ClusterConfig)[0]
Partitions = pyjq.all('.[].Partitions', ClusterConfig)[0]


NodeClass = 'holder3-cluster-compute'
print(json.dumps(pyjq.all('.[] as $p | $p.Nodes[] | select(.NodeName != null) | select(.NodeName | match("^{}.*$")) | $p'.format(NodeClass),Partitions),indent=2),"")

print(json.dumps(pyjq.all('.[].Controller', ClusterConfig),indent=2),"")
print(json.dumps(pyjq.all('keys[0]', ClusterConfig),indent=2),"")
print(json.dumps(pyjq.all('.[].Partitions', ClusterConfig),indent=2),"")
print("")

print(json.dumps(pyjq.all('.Region', ControllerConfig),indent=2),"")
print(json.dumps(pyjq.all('.Zone', ControllerConfig),indent=2),"")
print(json.dumps(pyjq.all('.NetworkType', ControllerConfig),indent=2),"")
print(json.dumps(pyjq.all('.SharedVPCHostProj', ControllerConfig),indent=2),"")
print(json.dumps(pyjq.all('.VPCSubnet', ControllerConfig),indent=2),"")
print(json.dumps(pyjq.all('.UpdateNodeAddresses', ControllerConfig),indent=2),"")
print(json.dumps(pyjq.all('.Project',ControllerConfig),indent=2),"")
print(json.dumps(pyjq.all('.ImageSource[].Project', ControllerConfig),indent=2),"")
print(json.dumps(pyjq.all('.ImageSource[].Image', ControllerConfig),indent=2),"")

DefaultPartition = pyjq.all('.DEFAULT',Partitions)[0]
print(json.dumps(DefaultPartition, indent=2))
for PartitionName, P in Partitions.items():

  Partition = merge(DefaultPartition, P)

 # print(json.dumps(Partition, indent=2))
  

  print("PartitionName = ", PartitionName)
  print(json.dumps(pyjq.all('.Project', Partition),indent=2))
  print(json.dumps(pyjq.all('.GpuType', Partition),indent=2))
  print(json.dumps(pyjq.all('.GpuCount', Partition),indent=2))
  print(json.dumps(pyjq.all('.Nodes[].NodeName', Partition),indent=2))
  print(json.dumps(pyjq.all('.InstanceParameters.Tags', Partition),indent=2))
  print(json.dumps(pyjq.all('.InstanceParameters.NetworkPath', Partition),indent=2))
  print(json.dumps(pyjq.all('.InstanceParameters.Preemptible', Partition),indent=2))
  print(json.dumps(pyjq.all('.InstanceParameters.Labels', Partition),indent=2))
  print(json.dumps(pyjq.all('.InstanceParameters.CPUPlatform', Partition),indent=2))
  print(json.dumps(pyjq.all('.InstanceParameters.BootDiskSize', Partition),indent=2))
  print(json.dumps(pyjq.all('.InstanceParameters.DiskType', Partition),indent=2))
  print(json.dumps(pyjq.all('.InstanceParameters.MachineType', Partition),indent=2))
  print("")
