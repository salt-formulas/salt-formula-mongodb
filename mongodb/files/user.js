{%- from "mongodb/map.jinja" import server with context -%}
db.addUser("admin","{{ server.admin.password }}")
db.auth("admin","{{ server.admin.password }}")
