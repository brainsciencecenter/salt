slurm:
  DbdHost: "holder3-cluster-controller"
  DbdDebugLevel: "debug"
  DbdLogFile: "/apps/slurm/log/slurmdbd.log"
  DbdPidFile: "/run/slurm/slurmdbd.pid"

  AccountingStorageType:  'accounting_storage/slurmdbd'
  ClusterName:  'holder3-cluster'
  ControlMachine:  'holder3-cluster-controller'
  SchedulerType:  'sched/backfill'
  SlurmctldDebug:  'debug'
  SlurmctldLogFile:  '/apps/slurm/log/slurm.log'
  SlurmDebug:  'debug'
  SlurmdLogFile:  '/apps/slurm/log/slurm.log'
  JobCompType:  'jobcomp/none'
  Nodes:  'NodeName=linux[1-32] Procs=1 State=UNKNOWN'
  Partitions:  'PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP'



