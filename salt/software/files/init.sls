sshd:
  service.running:
    - watch:
{% for FileName in salt['pillar.get']('files:etc:ssh') %}
      - file: /etc/ssh/{{ FileName }}
{% endfor %}

{% for FileName in salt['pillar.get']('files:etc:ssh') %}
/etc/ssh/{{ FileName }}:
  file.managed:
    - user: root
    - group: root
    {% if FileName | regex_match('^.*(.pub)$') %}
    - mode: 644
    {% else %}
    - mode: 600
    {% endif %}
    - makedirs: True
    - dir_mode: 0755
    - contents_pillar: files:etc:ssh:{{ FileName }}
{% endfor %}
