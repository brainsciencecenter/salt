{% set AppsDir = '/apps' %}
{% set SlurmDir = AppsDir + '/slurm' %}
{% set DownloadDir = '/apps/slurm/src' %}
{% set SrcDir = DownloadDir + '/slurm-19.05.5' %}

{% set AccountingStorageType = pillar.get('slurm:AccountStorageType', 'accounting_storage/slurmdbd') %}
{% set ClusterName = pillar.get('slurm:ClusterName', 'holder3-cluster') %}
{% set ControlMachine = pillar.get('slurm:ControlMachine', 'holder3-cluster-controller') %}
{% set SchedulerType = pillar.get('slurm:SchedulerType', 'sched/backfill') %}
{% set SlurmctldDebug = pillar.get('slurm:SlurmctldDebug', 'debug') %}
{% set SlurmctldLogFile = pillar.get('slurm:SlurmctldLogFile', '/apps/slurm/log/slurm.log') %}
{% set SlurmDebug = pillar.get('slurm:SlurmDebug', 'debug') %}
{% set SlurmdLogFile = pillar.get('slurm:LogFile', '/apps/slurm/log/slurm.log') %}
{% set JobCompType = pillar.get('slurm:Nodes', 'jobcomp/none') %}
{% set Nodes = pillar.get('slurm:', 'NodeName=linux[1-32] Procs=1 State=UNKNOWN') %}
{% set Partitions = pillar.get('slurm:Partitions', 'PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP') %}

{% set DbdHost = pillar.get('slurm:DbdHost', 'holder3-cluster-controller') %}
{% set DbdDebugLevel = pillar.get('slurm:DbdDebugLevel', 'debug') %}
{% set DbdLogFile = pillar.get('slurm:DbdLogFile', '/apps/slurm/log/slurmdbd.log') %}
{% set DbdPidFile = pillar.get('slurm:DbdPidFile', '/var/run/slurm/slurmdbd.pid') %}
{% set BuildDir = SrcDir + '/build' %}
{% set SlurmRootDir = '/apps/slurm/slurm-19.05.5' %}
{% set SlurmCurrent = '/apps/slurm/current' %}
{% set SlurmCurrentEtc = SlurmCurrent + '/etc' %}
{% set SlurmCurrentBin = SlurmCurrent + '/bin' %}
{% set SlurmScriptDir = SlurmDir + '/scripts' %}
{% set SlurmRun = '/var/run/slurm' %}
{% set SlurmScripts = ['compute-shutdown', 'custom-controller-install', 'slurm-gcp-sync.py', 'suspend.py', 'custom-compute-install', 'resume.py', 'startup-script.py' ] %}
{% set DefSlurmAccount = 'default' %}
{% set DefSlurmUsers = [ 'holder' ] %}

include:
  - {{ slspath }}/user+group

{% for script in SlurmScripts %}
{{ SlurmScriptDir }}/{{ script }}:
  file.managed:
    - source: salt://files/{{ SlurmScriptDir }}/{{ script }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
{% endfor %}

{{ SlurmDir }}/src:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - makedirs: True

/var/spool/slurm/ctld:
  file.directory:
    - user: slurm
    - group: slurm
    - dir_mode: 755
    - makedirs: True

InstallSlurm:
  cmd.run:
    - name: {{ SlurmScriptDir }}/startup-script.py
    - unless:
        test -e {{ SlurmRootDir }}

{{ SlurmScriptDir }}/cluster.yaml:
  file.managed:
    - source: salt://files{{ SlurmScriptDir }}/cluster.yaml
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

#slurm-link:
#  cmd.run:
#    - name: ln -s {{ SlurmRootDir }} {{ SlurmCurrent }}
#    - unless:
#        test -e {{ SlurmCurrent }}
#
#{{ SlurmCurrentEtc }}:
#  file.directory:
#    - user: root
#    - group: root
#    - dir_mode: 755
#    - makedirs: True
#
#slurm-clone:
#  cmd.run:
#    - name: wget https://download.schedmd.com/slurm/slurm-19.05.5.tar.bz2; tar -xf slurm-19.05.5.tar.bz2
#    - cwd: {{ DownloadDir }}
#    - unless:
#        test -e {{DownloadDir }}/slurm-19.05.5.tar.bz2
#
#slurm-configure:
#  cmd.run:
#    - name: mkdir build; cd build; ../configure --prefix={{ SlurmRootDir }} --sysconfdir={{ SlurmCurrentEtc }}
#    - cwd: {{ SrcDir }}
#    - unless:
#        test -e {{ BuildDir }}/config.status
#
#slurm-make:
#  cmd.run:
#    - name: make -j install
#    - cwd: {{ BuildDir }}
#    - unless:
#        test -e {{ SlurmRootDir }}
#
#python-pip:
#  pkg.installed
#
#google-api-python-client:
#  pip.installed:
#    - require:
#       - pkg: python-pip
#
{{ SlurmCurrentEtc }}/slurm.conf:
  file.managed:
    - source: salt://{{ slspath }}/slurm.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        AccountingStorageType: {{ AccountingStorageType }}
        ClusterName: {{ ClusterName }}
        ControlMachine: {{ ControlMachine }}
        SchedulerType: {{ SchedulerType }}
        SlurmctldDebug: {{ SlurmctldDebug }}
        SlurmctldLogFile: {{ SlurmctldLogFile }}
        SlurmDebug: {{ SlurmDebug }}
        SlurmdLogFile: {{ SlurmdLogFile }}
        JobCompType: {{ JobCompType }}
        Nodes: {{ Nodes }}
        Partitions: {{ Partitions }}


{{ SlurmCurrentEtc }}/slurmdbd.conf:
  file.managed:
    - source: salt://{{ slspath }}/slurmdbd.conf.jinja
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        DbdHost: {{ DbdHost }}
        DbdDebugLevel: {{ DbdDebugLevel }}
        DbdLogFile: {{ DbdLogFile }}
        DbdPidFile: {{ DbdPidFile }}


#{{ AppsDir }}/slurm/state:
#  file.directory:
#    - user: slurm
#    - group: slurm
#    - mode: 755 
#
#/apps/slurm/log:
#  file.directory:
#    - user: slurm
#    - group: slurm
#    - mode: 755 
#
#/etc/systemd/system/munge.service:
#  file.managed:
#    - source: salt://files/etc/systemd/system/munge.service
#    - user: root
#    - group: root
#    - mode: 644
#
#
/usr/lib/systemd/system/slurmctld.service:
  file.managed:
    - source: salt://{{ slspath }}/slurmctld.service.jinja
    - user: root
    - group: root
    - mode: 644
    - watch:
        - file: {{ SlurmCurrentEtc }}/slurm.conf
    - template: jinja
    - defaults:
        SlurmCurrent: {{ SlurmCurrent }}
        SlurmRun: {{ SlurmRun }}

/etc/systemd/system/slurmdbd.service:
  file.managed:
    - source: salt://{{ slspath }}/slurmdbd.service.jinja
    - name: 
    - user: root
    - group: root
    - mode: 644
    - watch:
        - file: {{ SlurmCurrentEtc }}/slurmdbd.conf
    - template: jinja
    - defaults:
        SlurmCurrent: {{ SlurmCurrent }}
        SlurmRun: {{ SlurmRun }}

#munge.service:
#  service.running:
#    - enable: True
#
#slurmdbd.service:
#  service.running:
#    - enable: True
#
#AddCluster:
#  cmd.run:
#    - name: {{ SlurmCurrentBin }}/sacctmgr -i add cluster {{ ClusterName }}
#    - unless:
#        {{ SlurmCurrentBin }}/sacctmgr list cluster format=cluster%30s | grep -q {{ ClusterName }}
#
#AddAccount:
#  cmd.run:
#    - name: {{ SlurmCurrentBin }}/sacctmgr -i add account {{ DefSlurmAccount }}
#    - unless:
#        {{ SlurmCurrentBin }}/sacctmgr list account {{ DefSlurmAccount }} format=account%30s | grep -q "{{ DefSlurmAccount }}"
#
#{% for user in DefSlurmUsers %}
#AddUser{{ user }}:
#  cmd.run:
#    - name: {{ SlurmCurrentBin }}/sacctmgr -i add user {{ user }} account={{ DefSlurmAccount }}
#    - unless:
#        {{ SlurmCurrentBin }}/sacctmgr list user {{ user }} format=user%30s | grep -q "{{ user }}"
#{% endfor %}
#
#slurmctld.service:
#  service.running:
#    - enable: True
#
#nfs-kernel-server:
#  pkg.installed
#   
#
##export:
##/etc/munge
##/apps
##/home
