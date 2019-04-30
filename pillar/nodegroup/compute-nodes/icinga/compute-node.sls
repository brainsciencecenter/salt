{% if nodes is not defined %}
{%   set nodes = [ salt['grains.get']('id') ] %}
{% endif %}

icinga:
{% for id in nodes %}
  {{ id }}:
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
      check_load
  
    time:
      check_ntp:
        minute: 2

    memory:
      check_memory:
        command_path: /usr/local/bin
        critical: 5000
        warning: 10000

    check_users:
      warning: 10
      critical: 20
{% endfor %}
