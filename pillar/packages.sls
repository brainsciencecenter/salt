packages:
  nagiosplugins:
{% if grains['os_family'] == 'RedHat' %}
    - nagios-plugins-all
{% elif grains['os'] == 'Ubuntu' %}
    - monitoring-plugins-basic
    - monitoring-plugins-common
    - nagios-plugins-contrib
{% elif grains['os_family'] == 'Debian' %}
    - nagios-plugins-common
    - nagios-plugins-basic
{% endif %}
