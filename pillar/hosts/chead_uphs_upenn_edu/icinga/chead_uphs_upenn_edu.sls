icinga:
  chead.uphs.upenn.edu:
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
  
    /var:
      check_disk:
        minute: '*/10'

    /export:
      check_disk:
        minute: '*/10'
        critical: 20\%
        warning: 40\%
  
    /export2:
      check_disk:
        minute: '*/10'
        critical: 20\%
        warning: 40\%
  
    load:
      check_load
  
    check_sensors:

    time:
      check_ntp:
        minute: 2

    check_users:
      warning: 10
      critical: 20

