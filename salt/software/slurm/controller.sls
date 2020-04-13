/share/apps/slurm/scripts/cluster.yaml:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://files/share/apps/slurm/scripts/cluster.yaml.{{ grains['id'] }}
    - makedirs: true
