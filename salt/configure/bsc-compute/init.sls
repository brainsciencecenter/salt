#
# slurm and munge users have to be define before all the packages get loaded and define more user and groups
#
include:
  - configure/timezone
  - software/slurm/user+group
  - configure/sshd
  - configure/gcp-packages
  - configure/vim
  - software/slurm/slurm-compute
