# Introduction

This directory contains files from the book *Cassandra the definitive guide* .


## Load schema

You run the cqlsh using kubectl like:

    CLUSTER_IP=$(kubectl get svc -lapp=cassandra -o jsonpath='{.items[0].spec.clusterIP}')
    kubectl run cqlsh -it -l role=devShell --rm=true --image=schnell18/cassandra:3.11.6 cqlsh $CLUSTER_IP

The `-l role=devShell` CLI option is vital to make the POD mount the currect directory.

Once you enter the cqlsh shell, you may load the `hotel` and `reservation` keyspaces as follows:

    source '/work/labs/cassandra/hotel/hotel.cql'
    source '/work/labs/cassandra/hotel/reservation.cql'

