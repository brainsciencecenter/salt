include:
  - icinga

/root/.ssh/id_rsa:
  file.managed:
    - source: salt://files/root/.ssh/compute.key
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

/root/.ssh/id_rsa.pub:
  file.managed:
    - source: salt://files/root/.ssh/compute.key.pub
    - user: root
    - group: root
    - mode: 600
    - makedirs: True

/root/.ssh/config:
  file.managed:
    - source: salt://files/root/.ssh/config
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
