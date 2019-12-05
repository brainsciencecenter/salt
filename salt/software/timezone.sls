{% if salt['pillar.get']('Timezone', None) != None %}
    {% set TimeZone = salt['pillar.get']('Timezone') %}
timezone:
  cmd.run:
    - name: timedatectl set-timezone {{ TimeZone }}
    - unless: timedatectl | grep -q {{ TimeZone }}
{% endif %}
