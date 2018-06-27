{%- from "mongodb/map.jinja" import server with context %}

{%- if server.get('enabled', False) %}
mongodb_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

/etc/mongodb.conf:
  file.managed:
  - source: salt://mongodb/files/mongodb.conf
  - template: jinja
  - require:
    - pkg: mongodb_packages

{%- if server.shared_key is defined %}
/etc/mongodb.key:
  file.managed:
  - contents_pillar: mongodb:server:shared_key
  - mode: 600
  - user: mongodb
  - require:
    - pkg: mongodb_packages
  - watch_in:
    - service: mongodb_service
{%- endif %}

{{ server.data_dir }}:
  file.directory:
    - makedirs: true

{{ server.lock_dir }}:
  file.directory:
    - makedirs: true

{{ server.logging.log_dir }}:
  file.directory:
    - makedirs: true

mongodb_service:
  service.running:
  - name: {{ server.service }}
  - enable: true
  {%- if grains.get('noservices') %}
  - onlyif: /bin/false
  {%- endif %}
  - require:
    - file: {{ server.lock_dir }}
    - pkg: mongodb_packages
  - watch:
    - file: /etc/mongodb.conf

{%- endif %}
