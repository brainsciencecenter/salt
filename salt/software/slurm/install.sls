{% set AppsDir = '/apps' %}
{% set SlurmDir = AppsDir + '/slurm' %}
{% set DownloadDir = '/apps/slurm/src' %}
{% set SrcDir = DownloadDir + '/slurm-19.05.5' %}
{% set ClusterName = 'holder-cluster' %}
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

slurm-group:
  group.present:
  - name: slurm
  - system: True

slurm-user:
  user.present:
    - name: slurm   
    - gid: slurm
    - home: /var/lib/slurm
    - createhome: True
    - system: True
    - shell: /bin/bash
    - fullname: Slurm User

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
#/etc/profile.d/slurm.sh:
#  file.managed:
#    - user: root
#    - group: root
#    - mode: 755
#    - source: salt://files/etc/profile.d/slurm.sh
#
#{{ SlurmCurrentEtc }}/slurm.conf:
#  file.managed:
#    - source: salt://{{ slspath }}/slurm.conf.jinja
#    - user: root
#    - group: root
#    - mode: 644
#    - template: jinja
#    - defaults:
#        AccountingStorageType: accounting_storage/slurmdbd
#        ClusterName: "holder-cluster"
#        ControlMachine: "holder"
#        SchedulerType: "sched/backfill"
#        SlurmctldDebug: "info"
#        SlurmctldLogFiile: "/apps/slurm/log/slurm.log"
#        SlurmDebug: "info"
#        SlurmdLogFile: "/apps/slurm/log/slurm.log"
#        JobCompType: "jobcomp/none"
#        Nodes: "NodeName=linux[1-32] Procs=1 State=UNKNOWN"
#        Partitions: "PartitionName=debug Nodes=ALL Default=YES MaxTime=INFINITE State=UP"
#
#
#{{ SlurmCurrentEtc }}/slurmdbd.conf:
#  file.managed:
#    - source: salt://{{ slspath }}/slurmdbd.conf.jinja
#    - user: root
#    - group: root
#    - mode: 644
#    - template: jinja
#    - defaults:
#        DbdHost: "holder"
#        DbdDebugLevel: "info"
#        DbdLogFile: "/apps/slurm/log/slurmdbd.log"
#        DbdPidFile: "/var/run/slurm/slurmdbd.pid"
#
#
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
#/etc/systemd/system/slurmctld.service:
#  file.managed:
#    - source: salt://{{ slspath }}/slurmctld.service.jinja
#    - user: root
#    - group: root
#    - mode: 644
#    - watch:
#        - file: {{ SlurmCurrentEtc }}/slurm.conf
#    - template: jinja
#    - defaults:
#        SlurmCurrent: {{ SlurmCurrent }}
#        SlurmRun: {{ SlurmRun }}
#
#/etc/systemd/system/slurmdbd.service:
#  file.managed:
#    - source: salt://{{ slspath }}/slurmdbd.service.jinja
#    - name: 
#    - user: root
#    - group: root
#    - mode: 644
#    - watch:
#        - file: {{ SlurmCurrentEtc }}/slurmdbd.conf
#    - template: jinja
#    - defaults:
#        SlurmCurrent: {{ SlurmCurrent }}
#        SlurmRun: {{ SlurmRun }}
#
##/etc/systemd/system/slurmd.service:
##  file.managed:
##    - source: salt://{{ slspath }}/slurmd.service.jinja
##    - name: 
##    - user: root
##    - group: root
##    - mode: 644
##    - template: jinja
##    - defaults:
##        SlurmCurrent: {{ SlurmCurrent }}
##        SlurmRun: {{ SlurmRun }}
##
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
