{%- from "mongodb/map.jinja" import server with context %}
rs.initiate({
    "_id": "{{ server.replica_set }}",
    "members": [
        {%- for member in server.members %}
        {
            "_id": {{ loop.index0 }},
            {%- if member.priority is defined %}
            "priority": {{ member.priority }},
            {%- endif %}
            "host": "{{ member.host }}"
        }{% if not loop.last %},{% endif %}
        {%- endfor %}
    ]
});
rs.conf();
