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

