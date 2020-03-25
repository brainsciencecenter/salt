#!/usr/bin/python3

# Copyright 2017 SchedMD LLC.
# Modified for use with the Slurm Resource Manager.
#
# Copyright 2015 Google Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import argparse
import httplib2
import json
import logging
import os
import pyjq
import re
import shlex
import subprocess
import sys
import time
import urllib.request, urllib.parse, urllib.error

import yaml

import googleapiclient.discovery
from google.auth import compute_engine
import google_auth_httplib2
from googleapiclient.http import set_user_agent

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


debug = False
debug = True

#
# *** ubuntu is hardcoded in main
#


def getMetadata(key):
    METADATA_URL = "http://metadata.google.internal/computeMetadata/v1/instance"

    req = urllib.request.Request("{}/{}".format(METADATA_URL, key))
    req.add_header('Metadata-Flavor', 'Google')
    try:
        resp = urllib.request.urlopen(req)
        return(resp.read().decode("utf-8"))
    except (urllib.error.HTTPError, Exception) as e:
        #logging.exception("Error : looking for '{}' in metadata failed".format(key))
        logging.info("Error : looking for '{}' in metadata failed".format(key))
        return(None)

def getNodePartition(NodeName, Partitions):
    NodeClass = re.sub("-?\d*$","", NodeName)
    print("NodeClass = ", NodeClass)

    DefaultPartition = pyjq.all('.DEFAULT',Partitions)[0]
    P = pyjq.all('.[] as $p | $p.Nodes[] | select(.NodeName != null) | select(.NodeName | match("^{}.*$")) | $p'.format(NodeClass), Partitions)[0]
    
    Partition = merge(DefaultPartition, P)
    return(Partition)

def getControllerConfig(ClusterConfig):
    return(pyjq.all('.[].Controller', ClusterConfig)[0])

def getPartitionsConfig(ClusterConfig):
    return(pyjq.all('.[].Partitions', ClusterConfig)[0])

SlurmDir = getMetadata('attributes/SlurmDir')
if (not SlurmDir):
    SlurmDir    = '/apps/slurm'

ClusterYAMLFile = SlurmDir + '/scripts/cluster.yaml'
if (os.path.exists(ClusterYAMLFile)):
    with open(ClusterYAMLFile) as file:
         ClusterConfig = yaml.load(file, Loader=yaml.FullLoader)
else:
    ClusterConfig = yaml.load(getMetadata('attributes/ClusterConfig'), Loader=yaml.FullLoader)

if (debug):
    print("ClusterConfig = ", json.dumps(ClusterConfig, indent=2))

CLUSTER_NAME = pyjq.all('keys[0]', ClusterConfig)[0]
ControllerConfig = getControllerConfig(ClusterConfig)
if (debug):
    print("ControllerConfig = ", json.dumps(ControllerConfig, indent=2))

PartitionsConfig = getPartitionsConfig(ClusterConfig)
if (debug):
    print("PartitionsConfig = ", json.dumps(PartitionsConfig, indent=2))

REGION       = pyjq.all('.Region', ControllerConfig)[0]
print("REGION = ", REGION)

PROJECT = None
Partition = None
    
SCONTROL     = SlurmDir + '/current/bin/scontrol'
LOGFILE      = SlurmDir + '/log/resume.log'

TOT_REQ_CNT = 1000

instances = {}
operations = {}
retry_list = []

credentials = compute_engine.Credentials()

http = set_user_agent(httplib2.Http(), "Slurm_GCP_Scripts/1.1 (GPN:SchedMD)")
authorized_http = google_auth_httplib2.AuthorizedHttp(credentials, http=http)

# [START wait_for_operation]
def wait_for_operation(compute, project, zone, operation):
    print('Waiting for operation to finish...')
    while True:
        result = compute.zoneOperations().get(
            project=project,
            zone=zone,
            operation=operation).execute()

        if result['status'] == 'DONE':
            print("done.")
            if 'error' in result:
                raise Exception(result['error'])
            return result

        time.sleep(1)
# [END wait_for_operation]

# [START update_slurm_node_addrs]
def update_slurm_node_addrs(compute):
    global ClusterConfig
    global ControllerConfig
    global Partition
    global operations

    ZONE        = pyjq.all('.InstanceParameters.Zone', Partition)[0]
    PROJECT     = pyjq.all('.InstanceParameters.Project', Partition)[0]

    print("update_slurm_node_addrs: Zone = {}, PROJECT = {}".format(ZONE, PROJECT))

    for node_name in operations:
        try:
            operation = operations[node_name]
            # Do this after the instances have been initialized and then wait
            # for all operations to finish. Then updates their addrs.
            wait_for_operation(compute, PROJECT, ZONE, operation['name'])

            my_fields = 'networkInterfaces(name,network,networkIP,subnetwork)'
            instance_networks = compute.instances().get(
                project=PROJECT, zone=ZONE, instance=node_name,
                fields=my_fields).execute()
            instance_ip = instance_networks['networkInterfaces'][0]['networkIP']

            node_update_cmd = "{} update node={} nodeaddr={}".format(
                SCONTROL, node_name, instance_ip)
            subprocess.call(shlex.split(node_update_cmd))

            logging.info("Instance " + node_name + " is now up")
        except Exception as  e:
            logging.exception("Error in adding {} to slurm ({})".format(
                node_name, str(e)))
# [END update_slurm_node_addrs]


# [START create_instance]
def create_instance(compute, project, zone, instance_type, instance_name,
                    source_disk_image, have_compute_img, disk_type, disk_size):

    global SlurmDir
    global ClusterConfig
    global ControllerConfig
    global PartitionConfig

    # Configure the machine
    machine_type = "zones/{}/machineTypes/{}".format(zone, instance_type)
    disk_path = "projects/{}/zones/{}/diskTypes/{}".format(project, zone,
                                                           disk_type)
    NETWORK_TYPE = pyjq.all('.NetworkType', ControllerConfig)[0]
    print("NETWORK_TYPE = ", NETWORK_TYPE)

    # node's project or shared vpc project
    NETWORK      = pyjq.all('.InstanceParmaters.NetworkPath', Partition)[0]


    config = {
        'name': instance_name,
        'machineType': machine_type,

        # Specify the boot disk and the image to use as a source.
        'disks': [{
            'boot': True,
            'autoDelete': True,
            'initializeParams': {
                'sourceImage': source_disk_image,
                'diskType': disk_path,
                'diskSizeGb': disk_size
            }
        }],

        # Specify a network interface
        'networkInterfaces': [{
            NETWORK_TYPE : NETWORK,
        }],

        # Allow the instance to access cloud storage and logging.
        'serviceAccounts': [{
            'email': 'default',
            'scopes': [
                'https://www.googleapis.com/auth/cloud-platform'
            ]
        }],

        'tags': { 'items': pyjq.all('.InstanceParameters.Tags', Partition)[0]} ,

        'metadata': {
            'items': [{
                'key': 'enable-oslogin',
                'value': 'TRUE'
            }]
        }
    }

    shutdown_script = open(
        SlurmDir + '/scripts/compute-shutdown', 'r').read()
    config['metadata']['items'].append({
        'key': 'shutdown-script',
        'value': shutdown_script
    })

    config['metadata']['items'].append({
        'key': 'ClusterConfig',
        'value': json.dumps(ClusterConfig, indent=2)
    })

    CloudInit = open(
            SlurmDir + '/scripts/cloud-config.yaml', 'r').read()
    config['metadata']['items'].append({
        'key': 'user-data',
        'value': CloudInit
    })

    """
    if not have_compute_img:
        startup_script = open(
            SlurmDir + '/scripts/compute-startup-script.py', 'r').read()
        config['metadata']['items'].append({
            'key': 'startup-script',
            'value': startup_script
        })
    """

    GPU_TYPE     = ''
    GPU_TYPE     = pyjq.all('.GPUType', Partition)[0]

    GPU_COUNT    = '0'
    GPU_COUNT    = pyjq.all('.GPUCount', Partition)[0]

    if GPU_TYPE:
        accel_type = ("https://www.googleapis.com/compute/v1/"
                      "projects/{}/zones/{}/acceleratorTypes/{}".format(
                          project, zone, GPU_TYPE))
        config['guestAccelerators'] = [{
            'acceleratorCount': GPU_COUNT,
            'acceleratorType' : accel_type
        }]

        config['scheduling'] = {'onHostMaintenance': 'TERMINATE'}

    PREEMPTIBLE  = pyjq.all('.InstanceParameters.Preemptible', Partition)[0]
    if PREEMPTIBLE:
        config['scheduling'] = {
            "preemptible": True,
            "onHostMaintenance": "TERMINATE",
            "automaticRestart": False
        },

    LABELS       = pyjq.all('.InstanceParameters.Labels', Partition)[0]
    if LABELS:
        config['labels'] = LABELS,

    CPU_PLATFORM = pyjq.all('.InstanceParameters.CPUPlatform', Partition)[0]
    if CPU_PLATFORM:
        config['minCpuPlatform'] = CPU_PLATFORM,

    SHARED_VPC_HOST_PROJ = pyjq.all('.SharedVPCHostProj', ControllerConfig)[0]
    
    VPC_SUBNET   = pyjq.all('.VPCSubnet', ControllerConfig)[0]
    if VPC_SUBNET:
        net_type = "projects/{}/regions/{}/subnetworks/{}".format(
            project, REGION, VPC_SUBNET)
        config['networkInterfaces'] = [{
            NETWORK_TYPE : net_type
        }]

    if SHARED_VPC_HOST_PROJ:
        net_type = "projects/{}/regions/{}/subnetworks/{}".format(
            SHARED_VPC_HOST_PROJ, REGION, VPC_SUBNET)
        config['networkInterfaces'] = [{
            NETWORK_TYPE : net_type
        }]

    EXTERNAL_IP  = pyjq.all('.InstanceParameters.ExternalIP', Partition)
    if EXTERNAL_IP:
        config['networkInterfaces'][0]['accessConfigs'] = [
            {'type': 'ONE_TO_ONE_NAT', 'name': 'External NAT'}
        ]

    if (debug):
        print("Config ", json.dumps(config, indent=2))

    return compute.instances().insert(
        project=project,
        zone=zone,
        body=config)
# [END create_instance]

# [START added_instances_cb]
def added_instances_cb(request_id, response, exception):
    if exception is not None:
        logging.error("add exception for node {}: {}".format(request_id,
                                                             str(exception)))
        if "Rate Limit Exceeded" in str(exception):
            retry_list.append(request_id)
    else:
        operations[request_id] = response
# [END added_instances_cb]

# [start add_instances]
def add_instances(compute, source_disk_image, have_compute_img, node_list):

    global ClusterConfig
    global ControllerConfig
    global PartitionsConfig
    global Partition

    global TOT_REQ_CNT

    batch_list = []
    curr_batch = 0
    req_cnt = 0
    batch_list.insert(
        curr_batch, compute.new_batch_http_request(callback=added_instances_cb))

    ZONE = pyjq.all('.Zone', ControllerConfig)[0]
    UPDATE_NODE_ADDRS = pyjq.all('.UpdateNodeAddresses', ControllerConfig)

    for node_name in node_list:
        if req_cnt >= TOT_REQ_CNT:
            req_cnt = 0
            curr_batch += 1
            batch_list.insert(
                curr_batch,
                compute.new_batch_http_request(callback=added_instances_cb))

        Partition = getNodePartition(node_name, PartitionsConfig)

        PROJECT = pyjq.all('.InstanceParameters.Project', Partition)[0]

        DISK_SIZE_GB = pyjq.all('.InstanceParameters.BootDiskSize', Partition)[0]

        DISK_TYPE    = pyjq.all('.InstanceParameters.DiskType', Partition)[0]

        MACHINE_TYPE = pyjq.all('.InstanceParameters."MachineType"', Partition)[0]

        print("PROJECT = ", PROJECT, "DISK_SIZE_GB = ", DISK_SIZE_GB, "MACHINE_TYPE = ", MACHINE_TYPE)

        batch_list[curr_batch].add(
            create_instance(
                compute, PROJECT, ZONE, MACHINE_TYPE, node_name,
                source_disk_image, have_compute_img, DISK_TYPE, DISK_SIZE_GB),
            request_id=node_name)
        req_cnt += 1

    try:
        for i, batch in enumerate(batch_list):
            batch.execute(http=http)
            if i < (len(batch_list) - 1):
                time.sleep(30)
    except Exception as  e:
        logging.exception("error in add batch: " + str(e))

    if UPDATE_NODE_ADDRS:
        update_slurm_node_addrs(compute)

# [END add_instances]

# [START main]
def main(arg_nodes):
    global ControllerConfig
    global Partition

    global SCONTROL
    global CLUSTER_NAME

    logging.debug("Bursting out:" + arg_nodes)
    compute = googleapiclient.discovery.build('compute', 'v1',
                                              http=authorized_http,
                                              cache_discovery=False)

    # Get node list
    show_hostname_cmd = "{} show hostnames {}".format(SCONTROL, arg_nodes)
    nodes_str = subprocess.check_output(shlex.split(show_hostname_cmd)).decode('utf-8')
    node_list = nodes_str.splitlines()

    have_compute_img = False

    #
    # *** The image project is probably not going to be the same as
    # the controller -- image should be part of admin, or bsc
    #
    ControllerProject = pyjq.all('.Project',ControllerConfig)[0]

    IMAGEPROJECT = pyjq.all('.ImageSource[].Project', ControllerConfig)[0]
    FAMILY = pyjq.all('.ImageSource[].Image', ControllerConfig)[0]

    print("ImageProject = ", IMAGEPROJECT, "FAMILY = ", FAMILY)

    try:
        #
        # *** This assumes the images are in the form ClusterName-compute-image
        # Need to change to have a central image pool
        #
        image_response = compute.images().getFromFamily(
            project = IMAGEPROJECT,
            family = FAMILY).execute()


            #family = CLUSTER_NAME + "-compute-image").execute()
        if image_response['status'] != "READY":
            logging.debug("image not ready, using the startup script")
            raise Exception("image not ready")
        source_disk_image = image_response['selfLink']
        have_compute_img = True
    except Exception as e:
        print("Main: failed find image {}/{}".format(IMAGEPROJECT, FAMILY), e)
        image_response = compute.images().getFromFamily(
            project='ubuntu-os-cloud', family='ubuntu-1910').execute()
        source_disk_image = image_response['selfLink']

    while True:
        add_instances(compute, source_disk_image, have_compute_img, node_list)
        if not len(retry_list):
            break;

        logging.debug("got {} nodes to retry ({})".
                      format(len(retry_list),",".join(retry_list)))
        node_list = list(retry_list)
        del retry_list[:]

    logging.debug("done adding instances")
# [END main]


if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('nodes', help='Nodes to burst')

    args = parser.parse_args()

    # silence module logging
    for logger in logging.Logger.manager.loggerDict:
        logging.getLogger(logger).setLevel(logging.WARNING)

    logging.basicConfig(
        filename=LOGFILE,
        format='%(asctime)s %(name)s %(levelname)s: %(message)s',
        Level=logging.DEBUG)

    main(args.nodes)
