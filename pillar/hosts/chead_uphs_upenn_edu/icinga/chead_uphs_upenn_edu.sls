icinga:
  chead.uphs.upenn.edu:
    procs:
      check_procs:
        name: [sshd]
        warning: '1:500'
        critical: '1:700'
  
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
      check_load:
        warning: 20
        critical: 50
  
    check_sensors:

    time:
      check_ntp:
        minute: 2

    check_users:
      warning: 200
      critical: 300

