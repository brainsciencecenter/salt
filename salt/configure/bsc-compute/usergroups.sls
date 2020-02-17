
ubuntuUser:
  user.absent:
    - name: ubuntu
    
ubuntuGroup:
  group.absent:
    - name: ubuntu

{% for GroupName, gid in pillar.get('bsc-groups', {}).items() %}
{{ GroupName }}Group:
  group.present:
    - name: {{ GroupName }}
    - gid: {{ gid }}

{% endfor %}

{% for UserName in pillar.get('bsc-users', {}) %}
{%   set uid = pillar.get('bsc-users', {})[UserName]['uid'] %}
{%   set gid = pillar.get('bsc-users', {})[UserName]['gid'] %}
{%   set fullname = pillar.get('bsc-users', {})[UserName]['fullname'] %}
{{ UserName }}:
  user.present:
    - uid: {{ uid }}
    - gid: {{ gid }}
    - fullname: {{ fullname }}

{% endfor %}

