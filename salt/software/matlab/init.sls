/share/apps/src/matlab-client-R2019a.tar:
  cmd.run:
    - name: gsutil cp gs://detre-backup/matlab/matlab-client-R2019a.tar /share/apps/src/matlab-client-R2019a.tar
    - unless: test -f /share/apps/src/matlab-client-R2019a.tar

/share/apps/tmp/MATLAB/R2019a:
  cmd.run:
    - name: tar -xf /share/apps/src/matlab-client-R2019a.tar -C /share/apps/tmp/MATLAB
    - unless: test -d /share/apps/tmp/MATLAB/R2019a

network.lic:
  file.managed:
    - name: /share/apps/MATLAB/R2019a/licenses/network.lic
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - source: salt://files/share/apps/MATLAB/licenses/network.lic.jinja
    - defaults:
        MatlabServerName: {{ salt['pillar.get']('MatlabServerName') }}
