packages:
  nagiosplugins:
{% if grains['os_family'] == 'RedHat' %}
    - nagios-plugins-all
{% elif grains['os_family'] == 'Debian' %}
    - nagios-plugins-basic
    - nagios-plugins-common
{% endif %}
