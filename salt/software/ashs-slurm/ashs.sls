python3:
  pkg.installed

cmake:
  pkg.installed

# vtk-devel: - CentOS
vtk-ubuntu:
  pkg.installed:
    - pkgs:
       - vtk7:
       - lvtk-dev

#qt-devel:
#  pkg.installed

#fltk-devel:
#  pkg.installed


ashs-repo:
  git.cloned:
    - name: https://github.com/pyushkevich/ashs
    - target: /share/apps/ashs/ashs-fastashs_2.0.0_07202018
    - user: root
    - branch: fastashs
