# Introduction

Simple etcd operator.

## create supporting resources

Create CRD role, service account, role-binding:

    kubectl apply -f cluster-crd.yaml
    kubectl apply -f operator-role.yaml
    kubectl apply -f operator-sa.yaml
    kubectl apply -f operator-rolebinding.yaml

## deploy operator

Type the following command to deploy the etcd operator

    kubectl apply -f operator-deployment.yaml

## deploy etcd cluster

Type the following command to deploy the etcd operator

    kubectl apply -f example-etcd-cluster.yaml

## run etcdctl client

Now you may connect the etcd cluster w/ etcdctl CLI as follows:

    kubectl run --rm -it etcdctl --image quay.io/coreos/etcd --restart=Never -- /bin/sh

In the CLI prompt, you type:

    export ETCDCTL_API=3
    export ETCDCSVC=http://example-etcd-cluster-client:2379
    etcdctl --endpoints $ETCDCSVC put foo bar
    etcdctl --endpoints $ETCDCSVC get foo

This test if simple key-value set/get operation is ok.
You may check the performance of the etcd cluster by typing:

    etcdctl --endpoints $ETCDCSVC check perf

Typical output looks like:

    / # etcdctl --endpoints $ETCDCSVC check perf
    60 / 60 Booooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo! 100.00%1m0s
    PASS: Throughput is 150 writes/s
    PASS: Slowest request took 0.084523s
    PASS: Stddev is 0.009967s
    PASS

## clean up

You may clean up the etcd operator lab by running commands as:


    kubectl delete -f example-etcd-cluster.yaml
    kubectl delete -f cluster-crd.yaml
    kubectl delete -f operator-deployment.yaml
    kubectl delete -f operator-rolebinding.yaml
    kubectl delete -f operator-role.yaml
    kubectl delete -f operator-sa.yaml
