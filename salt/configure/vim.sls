/etc/vim/vimrc.local:
  file.managed:
    - source: salt://files/etc/vim/vimrc.local
    - user: root
    - group: root
    - mode: 644
