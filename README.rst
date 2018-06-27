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
        shared_key: |
          bEoUQ4QKB8RsJt1cBnO8/2fni3CG+/L2CrGQ+RNJuA5cpIoeehHmWG1ir5mTUx9N
          OLLDvtHT6423395tmGBAJAISv5LXY8PNB6/m1LxsfEDEfjlLwo62z2pMG94ZBPX6
          pGy5YRlii77fi9l5/+d/ULFQSFy6uq5Py0qeFF1IsYsmeSP8GrCExw/9oxWj+Tmv
          qHcmRtm1EdaTKpAS2O07NMZTUxTO3SkaXzLZZF1QmflROcZq3ZteuM4jKBtOjKIt
          MlkkJ0rcIcahTw6x+iWQNDdip5uLS2Xc7i77ZMC4RZmeYVwQ16QtwNdNsTcnoeFC
          FfNIUXCckbZikhyUWlRUZd7NQ6YnQLGKi1Bs0YV0QLmocHFssiB9wnsNynMSgd4i
          zJ/joOlrqmIAmF8BJsa1D+szA4cHc0roWRiCfXvkVjL5fsPNXQpqu0ghPJXigoHJ
          7//HVsmNzX+Tb2hrHdHE+fnQgVmOgPbUPaPqTqwv9lfDeZj7kwn6pwrHZpcVLoTi
          ynv7Obl1dHJptRBXqEGBoYcJ2gDNBzuAN9QDpgueVn89s1x/LhHItItBRAwwlsMA
          T++Imel/9qA68kCSzjoj1GZw7CKAAoi9lZSKy5xVzo03K5ZYfaHdPFFG9wqncfH6
          tONxYHv1faQosjPJGQFcwPRqFYzPNzlIOnWYbFUwTJAvXGRcWui/XjpsjAwO7Ba/
          /7hDvlCBgAeor3dPo1d47eCH8ZjCc1pwd8v0fj2q3FvUTEJUsIjH4y3smlzZWR27
          Xx6lINe/i+OhwWH8538U4MWku52lbLn2G3pta7TJpVeVoZcNjs9tYWWeMjOmrcJH
          tPSe9zc5i+ZbD17npXRTlngaTP5ANKo6PlT2r2tzV06iYaSLyqVPoBA6evHwggcY
          AVw1v99wilvOisIP0n5QgTxpTLA8JHr3Erq7CCDDc+uUbrp0gAf+WATrM5HSNd2M
          YIaOzbYo5Mp71ofF8Xem/ce8GoCCypdWzvrT1DJMDxyt48DF
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


The shared_key can be generated through the use of the following open_ssl command:

.. code-block:: bash

openssl rand -base64 756


Read more
=========

* http://docs.mongodb.org/manual/
* http://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/
* http://docs.mongodb.com/manual/tutorial/deploy-replica-set-with-keyfile-access-control/
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
