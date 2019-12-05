#
# Add /share/apps to /usr/local/Modules/modulerc file
#
# Add to /etc/fstab
# /mnt/detre-group-data/share /share	none	x-systemd.after=/mnt/detre-group-data/share,bind	0	0
# /mnt/detre-group-data/data /data	none	x-systemd.after=/mnt/detre-group-data/data,bind	0	0
# /mnt/detre-group-data/home /home	none	x-systemd.after=/mnt/detre-group-data/home,bind	0	0

# Add matlab license server entry to /etc/hosts
# install required packages
#

include:
  - software/gpc-packages
  - software/zfs
  - software/timezone
  - software/ashs-slurm
  - software/itksnap
