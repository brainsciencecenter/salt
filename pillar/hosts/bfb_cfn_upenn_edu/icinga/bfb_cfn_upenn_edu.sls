icinga:
  bfb.cfn.upenn.edu:
    procs:
      check_procs:
        name: [sshd]
        warning: '1:5'
        critical: '1:10'
  
    check_apt:
  
    /: 
      check_disk:
        minute: '*/10'
        critical: 10\%
        warning: 20\%
  
    /boot:
      check_disk:
        minute: '*/10'
        critical: 20\%
        warning: 40\%
  
    /home:
      check_disk:
        minute: '*/10'
  
    load:
      check_load
  
    check_sensors:

    time:
      check_ntp:
        minute: 2

    Public IP Address:
      getPublicIPAddress:
        command_path: /usr/local/bin
        minute: '*/5'

    check_users:
      warning: 10
      critical: 20

