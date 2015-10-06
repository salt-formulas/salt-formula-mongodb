{%- if pillar.mongodb is defined %}
include:
  - mongodb.server
{%- endif %}