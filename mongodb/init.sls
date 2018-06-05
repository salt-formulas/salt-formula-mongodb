{%- if pillar.mongodb is defined %}
include:
  - mongodb.server
  - mongodb.cluster
{%- endif %}
