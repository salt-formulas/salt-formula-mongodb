=======
MongoDB
=======

MongoDB (from "humongous") is an open-source document database, and the leading NoSQL database. Written in C++.

Available states
================

.. contents::
    :local:

``mongodb.server``
--------------------

Setup MongoDB server

Available metadata
==================

.. contents::
    :local:

``metadata.mongodb.server.single``
----------------------------------

Single-node MongoDB setup

``metadata.mongodb.server.cluster``
-----------------------------------

Clustered MongoDB setup

Configuration parameters
========================


Example reclass
===============

Setup MongoDB with database for ceilometer.

.. code-block:: yaml

     classes:
     - service.mongodb.server.cluster
     parameters:
        _param:
          mongodb_server_replica_set: ceilometer
          mongodb_ceilometer_password: cloudlab
          mongodb_admin_password: cloudlab
          mongodb_shared_key: xxx
        mongodb:
          server:
            database:
              ceilometer:
                enabled: true
                password: ${_param:mongodb_ceilometer_password}
                users:
                -  name: ceilometer
                   password: ${_param:mongodb_ceilometer_password}

Sample pillars
==============

Simple single server

.. code-block:: yaml

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

Cluster of 3 nodes

.. code-block:: yaml

    mongodb:
      server:
        enabled: true
        logging:
          verbose: false
          logLevel: 1
          oplogLevel: 0
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

It's possible that first Salt run on master node won't pass correctly before
all slave nodes are up and ready.
Simply run salt again on master node to setup cluster, databases and users.

To check cluster status, execute following:

.. code-block:: bash

    mongo 127.0.0.1:27017/admin -u admin -p magicunicorn --eval "rs.status()"

Read more
=========

* http://docs.mongodb.org/manual/
* http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
* https://www.linode.com/docs/databases/mongodb/creating-a-mongodb-replication-set-on-ubuntu-12-04-precise

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-mongodb/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-mongodb

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
