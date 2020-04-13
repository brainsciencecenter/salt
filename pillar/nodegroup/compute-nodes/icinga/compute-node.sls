{% if nodes is not defined %}
{%   set nodes = [ salt['grains.get']('id') ] %}
{% endif %}

#{% for id in nodes %}
#  {{ id }}:
icinga:
  compute-0-0.chead.uphs.upenn.edu:
    procs:
      check_procs:
        name: [sshd]
        warning: '1:5'
        critical: '1:10'
  
    /: 
      check_disk:
        minute: '*/10'
        critical: 10\%
        warning: 20\%
  
    /var:
      check_disk:
        minute: '*/10'

    /tmp:
      check_disk:
        minute: '*/10'

    /state/partition1:
      check_disk:
        minute: '*/10'

    load:
      check_load:
        warning: 15
        critical: 20
  
    time:
      check_ntp:
        minute: '*/10'

    memory:
      check_memory:
        minute: '*/5'
        command_path: /usr/local/bin
        critical: 5000
        warning: 10000

    check_users:
      warning: 10
      critical: 20
#{% endfor %}
