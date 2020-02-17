#
# This only establishes the common group ids.
# The actual user lists should be done on the cluster controllers
#
# google-sudoers is 1001, ubuntu is 1000 starting at 1100
bsc-groups:
  munge: 1100
  slurm: 1101
  docker: 1102
  holder-group: 2999
  detre-group: 3000
  holder: 3002
  wtackett: 3003
  srdas: 3004
  sudiptod: 3005
  pauly2: 3006
  garcea: 3007
  li11: 4000

#
# BSC-users is only for service accounts which have to be accessible across
# NFS between controllers and compute nodes, our between clusters.
# Real user information is kept in the g-Suite directory
#
bsc-users:
  munge:
    uid: 1100
    gid: 1100
    fullname: Munge User

  slurm:
    uid: 1101
    gid: 1101
    fullname: Slurm User
   
  docker:
    uid: 1102
    gid: 1102
    fullname: Docker User

  