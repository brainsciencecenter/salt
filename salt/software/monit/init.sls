{% set PublicInterface = 'wlx00e04c1e4dbb' %}
monit-pkg:
  pkg.installed:
    - name: monit

monit-service:
  service.running:
    - name: monit
    - enable: true
    - watch:
        - file: /etc/monit/conf-enabled/PublicInterface

/usr/local/bin/resetPublicInterface:
  file.managed:
    - source: salt://files/usr/local/bin/resetPublicInterface
    - user: root
    - group: root
    - mode: 644

/etc/monit/conf-enabled/PublicInterface:
  file.managed:
    - source: salt://files/etc/monit/conf-enabled/PublicInterface
    - template: jinja
    - user: root
    - group: root
    - mode: 644
