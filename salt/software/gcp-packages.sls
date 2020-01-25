AddAptGetKey:
  cmd.run:
    - name: curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    - unless: apt-key list | grep -q 'Google Cloud Packages Automatic Signing Key <gc-team@google.com>'

gcp-packages:
  pkg.installed:
    - pkgs:
      - tmux
      - emacs
      - iproute2
      - jq
      - nmap
      - python3
      - python3-pip
      - strace
      - unzip
      - x11-apps

# pip3 installed flywheel-sdk globre tzlocal 
# pip install flywheel-sdk
# fw command unzipped from wget https://storage.googleapis.com/flywheel-dist/cli/10.3.1/fw-linux_amd64.zip
