{%- from 'nrpe/map.jinja' import nrpe with context -%}

# Install generic plugins for nagios checks defined in pillar
nrpe_generic_pkg:
  pkg.installed:
    - pkgs:
      {%- for plugin in nrpe.plugins %}
      - nagios-plugins-{{plugin}}
      {%- endfor %}
    - require:
      - pkg: nrpe_pkg
    - watch_in:
      - service: nrpe_service
