AddAptGetKey:
  cmd.run:
    - name: curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    - unless: apt-key list | grep -q 'Google Cloud Packages Automatic Signing Key <gc-team@google.com>'

gcp-packages:
  pkg.installed:
    - pkgs:
      - aptitude
      - bind9-host
      - build-essential
      - checkinstall
      - colord
      - csvkit
      - docker
      - dnsutils
      - emacs
      - environment-modules
      - finger
      - firefox
      - gdm3
      - git
      - gnome-panel
      - gnome-settings-daemon
      - gnome-terminal
      - hwloc
      - iproute2
      - jq
      - libextutils-makemaker-cpanfile-perl
      - libhwloc-dev
      - liblua5.3-dev
      - libmariadb-dev
      - libmariadbclient-dev
      - libmunge-dev
      - libmunge2
      - libncurses-dev
      - libnfs-utils
      - libnuma-dev
      - libopenmpi-dev
      - libpam0g-dev
      - libpam0g-dev
      - libqt4-opengl-dev
      - libreadline-dev
      - librrd-dev
      - libssl-dev
      - linux-headers-gcp
      - lua5.3
      - man2html
      - mariadb-client
      - metacity
      - munge
      - nautilus
      - nfs-common
      - mlocate
      - nmap
      - numactl
      - openmpi-bin
      - pdsh
      - python-pip
      - python3
      - python3-pip
      - ruby
      - ruby-dev
      - singularity-container
      - strace
      - tightvncserver
      - tmux
      - unzip
      - vim
      - wget
      - x11-apps
      - xfce4
      - xfonts-100dpi
      - xfonts-75dpi

yq:
  snap.installed

# pip3 installed flywheel-sdk globre tzlocal 
# pip install flywheel-sdk
# fw command unzipped from wget https://storage.googleapis.com/flywheel-dist/cli/10.3.1/fw-linux_amd64.zip
