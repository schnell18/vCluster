# Introduction

This is a practice to create a cassandra cluster.  This practice is
based on the offical kubernentes tutorial [Deploying Cassandra with
Stateful Sets][1] with minor modification to take advantage of gcr
docker image mirror in China and local storage.

## Deployment instructions

You create the cassandra stateful set, then the service.

To create the cassandra stateful set, run the follow command:

    kubectl apply -f cassandra-statefulset.yaml

To create the cassandra service, run the follow command:

    kubectl apply -f cassandra-service.yaml

Or to run these commands in one go, you type:

    kubectl apply -f cassandra-statefulset.yaml
    kubectl apply -f cassandra-service.yaml

## Access the cassandra console

Check cluster status:

    kubectl exec -it cassandra-0 -- nodetool status

This lab uses node port to expose service outside cluster. To locate the port, run command as follows:

    kubectl get svc -lapp=cassandra

Locate the node where cassandra runs:

    kubectl get pod -lapp=cassandra

Then you use the cqlsh inside the cluster to connect to the cassandra:

    CLUSTER_IP=$(kubectl get svc -lapp=cassandra -o jsonpath='{.items[0].spec.clusterIP}')
    kubectl run cqlsh -it -l role=devShell --rm=true --image=schnell18/cassandra:3.11.6 cqlsh $CLUSTER_IP


## Access cassandra w/ Python

The small project under *employee/python* demonstrates how to access cassandra in Python.
This project uses the [cassandra-driver][2]. You may refer to the API documentation hosted
at [datastax][3].

[1]: https://kubernetes.io/docs/tutorials/stateful-application/cassandra/
[2]: https://pypi.org/project/cassandra-driver/
[3]: https://docs.datastax.com/en/developer/python-driver/3.22/api/cassandra/cluster/
