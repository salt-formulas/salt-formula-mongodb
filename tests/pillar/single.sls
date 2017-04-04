mongodb:
  server:
    enabled: true
    bind:
      address: 0.0.0.0
      port: 27017
    admin:
      username: admin
      password: magicunicorn
    database:
      dbname:
        enabled: true
        encoding: 'utf8'
        users:
        - name: 'username'
          password: 'password'
ceilometer:
  server:
    database:
      password: 'password'
