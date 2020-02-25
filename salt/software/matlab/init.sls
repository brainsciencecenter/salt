/share/apps/src/matlab-client-R2019a.tar:
  cmd.run:
    - name: gsutil cp gs://repo.pennbrain.upenn.edu/matlab/matlab-client-R2019a.tar /share/apps/src/matlab-client-R2019a.tar
    - unless: test -f /share/apps/src/matlab-client-R2019a.tar

/share/apps/MATLAB:
  file.directory:
    - user: root
    - group: root
    - mode: 755

/share/apps/MATLAB/R2019a:
  cmd.run:
    - name: tar -xf /share/apps/src/matlab-client-R2019a.tar -C /share/apps/MATLAB
    - unless: test -d /share/apps/MATLAB/R2019a

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

lsb:
  pkg.installed
