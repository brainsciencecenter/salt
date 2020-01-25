munge_dependancies:
  pkg.installed:
    - pkgs:
      - libmunge-dev
      - libmunge2
      - munge

munge:
  service.running:
    - enable: True
 
