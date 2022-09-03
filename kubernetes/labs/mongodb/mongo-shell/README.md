# Introduction

Connect to mongo with CLI:

    kubectl apply -f noop-shell.yaml
    kubectl exec -it noop-shell bash

    mongo mongodb://admin:abc123@mongod-0.mongodb-service,mongod-1.mongodb-service,mongod-2.mongodb-service/?authSource=admin\&replicaSet=MainRepSet


## create database users


    mongo --eval "db.getSiblingDB('wekan').createUser({
          user : \"wekan\",
          pwd  : \"wekan\",
          roles: [ { role: 'readWrite', db: 'wekan' } ]
    });"

    mongo --eval "db.getSiblingDB('titra').createUser({
          user : \"titra\",
          pwd  : \"titra\",
          roles: [ { role: 'readWrite', db: 'titra' } ]
    });"

