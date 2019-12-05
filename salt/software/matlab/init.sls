#
# Add matlab server to /etc/hosts
#
#
# copy in fix-eth1-mac-address 
#
# copy in fix-eth1-mac-address.service and matlab-server.service
# enable both services
#
fs.protected_symlinks:
  sysctl.present:
    - value: 0
