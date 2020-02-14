getGCPAutoSnapshot:
  cmd.run:
    - name: (cd /usr/local/bin; wget https://gitlab.com/alan8/google-cloud-auto-snapshot/raw/master/google-cloud-auto-snapshot.sh)
    - unless:
       test -e /usr/local/bin/google-cloud-aut-snapshot.sh
       
/usr/local/bin/google-cloud-auto-snapshot.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755

/var/log/gcp-snapshot/snapshot.log:
  file.managed:
    - user: root
    - group: adm
    - mode: 664
    - makedirs: true

/etc/logrotate.d/gcp-snapshot:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: 
      - /var/log/snapshot/*.log { daily missingok rotate 14 compress notifempty create 664 root adm sharedscripts }
      
GCPAutoSnapshotCron:
  cron.present:
    - name: "/usr/local/bin/google-cloud-auto-snapshot.sh >> /var/log/snapshot/snapshot.log 2>&1"
    - user: root
    - minute: 0
    - hour: 5
    - daymonth: "*"
    - month: "*"
    - dayweek: "*"
