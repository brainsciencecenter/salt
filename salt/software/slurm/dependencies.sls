slurm_dependancies:
  pkg.installed:
    - pkgs:
      - bind9-host
      - build-essential
      - dnsutils
      - git
      - checkinstall
      - environment-modules
      - ruby
      - ruby-dev
      - libpam0g-dev
      - libmariadbclient-dev
      - hwloc
      - libhwloc-dev
      - lua5.3
      - liblua5.3-dev
      - man2html
      - mariadb-client
      - libmariadb-dev
      - mariadb-server
      - munge
      - libmunge-dev
      - linux-headers-gcp
      - libmunge2
      - libncurses-dev
      - libnfs-utils
      - numactl
      - libnuma-dev
      - libssl-dev
      - libpam0g-dev
      - libextutils-makemaker-cpanfile-perl
      - python-pip
      - libreadline-dev
      - librrd-dev
      - vim
      - wget
      - tmux
      - pdsh
      - openmpi-bin
      - x2goserver
      - libopenmpi-dev
fpm:
  cmd.run:
    - name: gem install fpm
    - unless:
       gem list | grep -q fpm

