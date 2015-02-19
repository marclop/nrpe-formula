{% from 'nrpe/map.jinja' import nrpe with context -%}
{% set hostname = grains['host'] %}

{% if grains['osarch'] == 'x86_64' %}
  {% set libarch = 'lib64' %}
{% else %}
  {% set libarch = 'lib' %}
{% endif %}

{% if 'mysql' in nrpe %}
{% if hostname in nrpe.mysql %}
{% if pillar['nrpe']['mysql'][hostname]['galera'] is defined %}
{% if pillar['nrpe']['mysql'][hostname]['galera'] == True %}

nrpe_mysql_galera_pkg:
  pkg.installed:
    - name: percona-nagios-plugins
{% endif %} # END filter galera True
{% endif %} # END filter galera exists

nrpe_mysql_pkg:
  pkg.installed:
    - name: nagios-plugins-mysql

nrpe_mysql_cfg:
  file.managed:
    - name: {{ nrpe.conf_include_dir }}/mysql.cfg
    - makedirs: True
    - template: jinja
    - source: salt://nrpe/files/mysql/mysql.cfg
    - defaults:
        libarch: {{ libarch }}
    - require:
      - pkg: nrpe_pkg
    - watch_in:
      - service: nrpe_service

{% endif %} # END filter host in pillar
{% endif %} # END filter mysql in pillar
