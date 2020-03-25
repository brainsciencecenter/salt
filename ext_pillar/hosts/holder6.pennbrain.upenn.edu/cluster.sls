#
# tags, image-source, nfs mounts all have dashes
# labels do not
# Nothing else should have dashes
# 

holder6-cluster:
  SlurmDbd:
    SlurmDbdFile: /apps/slurm/current/slurmdbd.conf
    DbdHost: holder6-cluster-controller
    DebugLevel: debug
    LogFile: /apps/slurm/log/slurmdbd.log
    PidFile: /run/slurm/slurmdbd.pid

  SlurmConf:
    AccountingStorageHost: holder6-cluster-controller
    AccountingStorageType: accounting_storage/slurmdbd
    ClusterName: holder6-cluster
    ControlMachine: holder6-cluster-controller
    ResumeFailProgram: /apps/slurm/scripts/suspend.py
    ResumeProgram: /apps/slurm/scripts/resume.py
    ResumeTimeout: 600
    SchedulerType: sched/backfill
    SelectType: select/cons_res
    SelectTypeParameters: CR_Core_Memory
    SlurmctldDebug: info
    SlurmctldLogFile: /apps/slurm/log/slurmctld.log
    SlurmctldPidFile: /run/slurm/slurmctld.pid
    SlurmdDebug: debug
    SlurmdLogFile: /var/log/slurm/slurmd-%n.log
    SlurmdPidFile: /run/slurm/slurmd.pid
    SlurmdSpoolDir: /var/spool/slurmd 
    StateSaveLocation: /apps/slurm/state
    SuspendProgram: /apps/slurm/scripts/suspend.py
    SuspendTime: 120
    SuspendTimeout: 60

  Controller:
    Project: holder6-pennbrain-upenn-edu
    FolderId: 634062205321
    Group: holder6
    BillingAccountId: 010E05-389CEA-FDE7D9
    ImageSource:
      - Image: bsc-compute-image
        Project: pennbrain-center
    MinionId: holder6.pennbrain.upenn.edu
    Tags:
      - controller
    Labels:
      billing-project: holder6-pennbrain-upenn-edu
    Nfs:
      - /apps
      - /home
      - /etc/munge
    MachineType: n1-standard-2
    BootDiskSize: 20
    DiskType: pd-standard
    Zone: us-east1-b
    Region: us-east1
    ServiceAccount: slurm-user@holder6-pennbrain-upenn-edu.iam.gserviceaccount.com
    ExternalIp: 35.231.255.20
    Network: bsc-host-network
    Subnet: holder6-subnet
    VPCNetworkProjectId: pennbrain-host-3097383fff
    VPCNetworkName: holder6-subnet
    NetworkType: subnetwork
    UpdateNodeAddresses: True
    
  Partitions:
    DEFAULT:
        PartitionParameters:
            MaxTime: INFINITE
            LLN: yes
            State: UP
            DefMemPerCPU: 2000
        Nodes:
          - NodeName: DEFAULT
          - State: CLOUD
          - Sockets: 1
          - CoresPerSocket: 1
          - ThreadsPerCore: 1
          - RealMemory: 3000

        InstanceParameters:
            ImageSource:
              - Image: bsc-compute-image
                Project: pennbrain-center
            Region: us-east1
            Zone: us-east1-b
            Preemptible: True
            BootDiskSize: 10
            DiskType: pd-standard
            MachineType: n1-standard-2
            NetworkPath: projects/pennbrain-host-3097383fff/global/networks/holder6-cluster
            Labels:
              key1: value1
              key2: value2
            Tags:
              - tag1
              - tag2
            GpuType: 
            GpuCount: 0

    debug:
        PartitionParameters:
            Default: YES
        Nodes:
          - NodeName: holder6-cluster-compute[0-2]

        InstanceParameters:
            Project: holder6-pennbrain-upenn-edu
            BootDiskSize: 10
            DiskType: pd-standard
            MachineType: n1-standard-2
            Preemptible: True
            Tags:
              - compute
            Labels:
              billing-project: holder6-pennbrain-upenn-edu

    debug2:
        Nodes:
          - NodeName: debug2-compute[0-2]

        InstanceParameters:
            Project: holder6-pennbrain-upenn-edu
            Tags:
              - compute
            Labels:
              billing-project: holder6-pennbrain-upenn-edu

