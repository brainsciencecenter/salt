itk:
  pip.installed

itksnap-repo:
  git.cloned:
    - name: https://git.code.sf.net/p/itk-snap/src
    - target: /share/apps/src/itksnap
    - user: root
    - branch: master

itksnap-repo-submodule:
    - submodules: True


