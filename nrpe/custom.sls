{%- from 'nrpe/map.jinja' import nrpe with context -%}

# Set the apropriate architecture path
{% if grains['osarch'] == 'x86_64' %}
  {% set libarch = 'lib64' %}
{% else %}
  {% set libarch = 'lib' %}
{% endif %}

# NRPE configs .cfg
nrpe_custom_cfg:
  file.recurse:
    - name: {{ nrpe.conf_include_dir }}
    - template: jinja
    - source: salt://nrpe/files/nrpe.d
    - clean: False
    - defaults:
        libarch: {{ libarch }}
    - watch_in:
      - service: nrpe_service

# Plug-in Binaries
nrpe_custom_binaries:
  file.recurse:
    - name: /usr/{{ libarch }}/nagios/plugins/
    - source: salt://nrpe/files/nrpe.d
    - user: root
    - group: root
    - file_mode: 655
    - clean: False
    - watch_in:
      - service: nrpe_service
