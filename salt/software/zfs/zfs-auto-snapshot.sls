zfs-auto-snapshot:
  pkg.installed

#DownloadZFSAutoSnapShot:
#  cmd.run:
#    - name: wget -O /tmp/1.2.4.tar.gz https://github.com/zfsonlinux/zfs-auto-snapshot/archive/upstream/1.2.4.tar.gz
#    - unless: ls -ld /tmp/1.2.4.tar.gz
#
#MkDirZFSAutoSnapshot:
#  cmd.run:
#    - name: mkdir /mnt/zfs/apps/zfs-auto-snapshot
#    - unless: ls -ld /mnt/zfs/apps/zfs-auto-snapshot
#
#UntarZFSAutoSnapShot:
#  cmd.run:
#    - name: tar -xzf /tmp/1.2.4.tar.gz -C /mnt/zfs/apps/zfs-auto-snapshot
#    - unless: ls -ld /mnt/zfs/apps/zfs-auto-snapshot/zfs-auto-snapshot-upstream-1.2.4
#
#InstallZFSAutoSnapShot:
#  cmd.run:
#    - name: cd /mnt/zfs/apps/zfs-auto-snapshot/zfs-auto-snapshot-upstream-1.2.4 ; make install
#    - unless: ls -ld /mnt/zfs/etc/cron.d/zfs-auto-snapshot
