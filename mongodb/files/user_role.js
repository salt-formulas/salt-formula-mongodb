{%- from "mongodb/map.jinja" import server with context -%}
db = db.getSiblingDB("{{ database_name }}");
db.addUser({user: "{{ database_name }}", pwd: "{{ pillar.ceilometer.server.database.password }}",roles: [ "readWrite", "dbAdmin" ]});
