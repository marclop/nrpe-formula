{%- from 'nrpe/map.jinja' import nrpe with context -%}

nrpe_pkg:
  pkg.installed:
    - name: {{ nrpe.pkg }}

# Set value for allowed_hosts
nrpe_allowed_hosts:
  file.replace:
    - name: {{ nrpe.conf_path }}
    - pattern: '^allowed_hosts=.*'
    - repl: "allowed_hosts={{ nrpe.conf_allowed_hosts }}"
    - require:
      - pkg: nrpe_pkg
    - unless:
      - grep "allowed_hosts={{ nrpe.conf_allowed_hosts }}" {{ nrpe.conf_path }}
    - watch_in:
      - service: nrpe_service

# Set the value for dont_blame_nrpe
nrpe_blame_nrpe:
  file.replace:
    - name: {{ nrpe.conf_path }}
    - pattern: '^dont_blame_nrpe=.*'
    - repl: "dont_blame_nrpe={{ nrpe.conf_blame_nrpe }}"
    - require:
      - pkg: nrpe_pkg
    - unless:
      - grep "dont_blame_nrpe={{ nrpe.conf_blame_nrpe }}" {{ nrpe.conf_path }}
    - watch_in:
      - service: nrpe_service

# Set the value for include_dir
nrpe_include_dir:
  file.replace:
    - name: {{ nrpe.conf_path }}
    - pattern: '^include_dir=.*'
    - makedirs: True
    - repl: "include_dir={{ nrpe.conf_include_dir }}"
    - append_if_not_found: True
    - require:
      - pkg: nrpe_pkg
    - unless:
      - grep "include_dir={{ nrpe.conf_include_dir }}" {{ nrpe.conf_path }}
    - watch_in:
      - service: nrpe_service

nrpe_service:
  service.running:
    - name: {{ nrpe.service }}
    - enable: True
    - reload: False
    - watch:
      - pkg: nrpe_pkg
