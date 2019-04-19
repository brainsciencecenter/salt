nagios-plugins:
  pkg.installed:
    - pkgs:
        {{ salt['pillar.get']('packages:nagiosplugins', 'nagios-plugins-contrib') }}

