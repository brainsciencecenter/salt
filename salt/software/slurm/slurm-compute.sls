{% set ClusterName = salt['pillar.get']('ClusterConfig') %}
{% set SlurmDir = salt['pillar.get'](ClusterName + ':SlurmDir') %}

{% set SlurmCurrent = SlurmDir + '/current' %}
{% set SlurmRun = '/run/slurm' %}
{% set ComputeNodeScripts = [ 'fixbsccomputeimage', 'fixNFSMounts', 'getSlurmDir' ] %}

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

{% for f in ComputeNodeScripts %}
{{ f }}:
  file.managed:
    - name: /usr/local/bin/{{ f }}
    - user: root
    - group: root
    - mode: 755
    - source: salt://files/usr/local/bin/{{ f }}
{% endfor %}

slurmd:
  service.running:
    - enable: True

makeSureSlurmdIsEnabled:
  cmd.run:
    - name: systemctl enable slurmd
