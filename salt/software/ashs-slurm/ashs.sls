python3:
  pkg.installed

itk:
  pip.installed

itksnap-repo:
  git.latest:
    - name: https://git.code.sf.net/p/itk-snap/src
    - target: /share/apps/src/itksnap
    - user: root
    - branch: master
    - submodules: True

cmake:
  pkg.installed

# vtk-devel: - CentOS
vtk-ubuntu:
  pkg.installed:
    - pkgs:
       - vtk7:
       - lvtk-dev

qt-devel:
  pkg.installed

fltk-devel:
  pkg.installed


ashs-repo:
  git.latest:
    - name: https://github.com/pyushkevich/ashs.git
    - target: /share/apps/src/ashs
    - user: root
    - branch: master
