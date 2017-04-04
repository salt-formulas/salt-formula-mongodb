mongodb:
  server:
    enabled: true
    admin:
      user: admin
      password: magicunicorn
    master: mongo01
    members:
      - host: 192.168.1.11
        priority: 2
      - host: 192.168.1.12
      - host: 192.168.1.13
    replica_set: default
    shared_key: magicunicorn
linux:
  system:
    name: name
