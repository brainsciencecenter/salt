mariadb-server:
  pkg.installed:
  - pkgs:
    - mariadb-server

mariadb-service:
  service.running:
    - name: mysql
    - enable: True
