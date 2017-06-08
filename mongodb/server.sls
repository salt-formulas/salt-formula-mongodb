{%- from "mongodb/map.jinja" import server with context %}
{%- if server.enabled %}

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

{{ server.lock_dir }}:
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

{%- if server.members is not defined  or server.master == pillar.linux.system.name %}
{# We are not a cluster or we are master #}

/var/tmp/mongodb_user.js:
  file.managed:
  - source: salt://mongodb/files/user.js
  - template: jinja
  - mode: 600
  - user: root

mongodb_change_root_password:
  cmd.run:
  - name: 'mongo localhost:27017/admin /var/tmp/mongodb_user.js && touch {{ server.lock_dir }}/mongodb_password_changed'
  {%- if grains.get('noservices') %}
  - onlyif: /bin/false
  {%- endif %}
  - require:
    - file: /var/tmp/mongodb_user.js
    - service: mongodb_service
  - creates: {{ server.lock_dir }}/mongodb_password_changed

{%- for database_name, database in server.get('database', {}).iteritems() %}

/var/tmp/mongodb_user_{{ database_name }}.js:
  file.managed:
  - source: salt://mongodb/files/user_role.js
  - template: jinja
  - mode: 600
  - user: root
  - defaults:
      database_name: {{ database_name }}

mongodb_{{ database_name }}_fix_role:
  cmd.run:
  - name: 'mongo localhost:27017/admin -u admin -p {{ server.admin.password }} /var/tmp/mongodb_user_{{ database_name }}.js && touch {{ server.lock_dir }}/mongodb_user_{{ database_name }}_created'
  {%- if grains.get('noservices') %}
  - onlyif: /bin/false
  {%- endif %}
  - require:
    - file: /var/tmp/mongodb_user_{{ database_name }}.js
    - service: mongodb_service
  - creates: {{ server.lock_dir }}/mongodb_user_{{ database_name }}_created
  {%- if server.members is defined %}
  require:
    - cmd: mongodb_setup_cluster
  {%- endif %}

{%- endfor %}

{%- if server.members is defined %}

/var/tmp/mongodb_cluster.js:
  file.managed:
  - source: salt://mongodb/files/cluster.js
  - template: jinja
  - mode: 600
  - user: root

mongodb_setup_cluster:
  cmd.run:
  - name: 'mongo localhost:27017/admin /var/tmp/mongodb_cluster.js && mongo localhost:27017/admin --quiet --eval "rs.conf()" | grep object -q'
  - unless: 'mongo localhost:27017/admin -u admin -p {{ server.admin.password }} --quiet --eval "rs.conf()" | grep object -q'
  - require:
    - service: mongodb_service
    - file: /var/tmp/mongodb_cluster.js
  - require_in:
    - cmd: mongodb_change_root_password

{%- endif %}

{%- endif %}

{%- endif %}
