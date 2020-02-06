{% set SlurmControllerName = 'holder-cluster-controller' %}
{% set SlurmCurrent = '/apps/slurm/current' %}
{% set SlurmRun = '/var/run/slurm' %}
{% set NFSMounts = [ '/apps', '/home', '/etc/munge' ] %}

/var/log/slurm:
  file.directory:
    - user: slurm
    - group: slurm
    - dir_mode: 755
    - makedirs: True

/etc/profile.d/slurm.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    - source: salt://files/etc/profile.d/slurm.sh

/usr/lib/systemd/system/munge.service:
  file.managed:
    - source: salt://files/usr/lib/systemd/system/munge.service
    - name: 
    - user: root
    - group: root
    - mode: 644

/usr/lib/systemd/system/slurmd.service:
  file.managed:
    - source: salt://{{ slspath }}/slurmd.service.jinja
    - name: 
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        SlurmCurrent: {{ SlurmCurrent }}
        SlurmRun: {{ SlurmRun }}

{% for MountPoint in NFSMounts %}
{{ MountPoint }}:
  mount.mounted:
    - device: {{ SlurmControllerName }}:{{ MountPoint }}
    - fstype: nfs
    - mkmnt: True
    - opts:
        - defaults
{% endfor %}

slurmd:
  service.running:
    - enable: True

makeSureSlurmdIsEnabled:
  cmd.run:
    - name: systemctl enable slurmd
