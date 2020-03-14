# Introduction

This is a practice to create simple guest book web application backed by
redis. This practice is based on the offical kubernentes tutorial [Deploying
PHP Guestbook application with Redis][1] with minor modification to take
advantage of gcr docker image mirror in China.

## Deployment instructions

You create the redis-master and redis-slave, then PHP web front.

To create the redis-master, run the follow command:

    kubectl apply -f redis-master-deployment.yaml
    kubectl apply -f redis-master-service.yaml

To create the redis-slave, run the follow command:

    kubectl apply -f redis-slave-deployment.yaml
    kubectl apply -f redis-slave-service.yaml

The you may create the web front with following command:

    kubectl apply -f frontend-deployment.yaml
    kubectl apply -f frontend-service.yaml

Or to run these commands in one go, you type:

    kubectl apply -f redis-master-deployment.yaml
    kubectl apply -f redis-master-service.yaml
    kubectl apply -f redis-slave-deployment.yaml
    kubectl apply -f redis-slave-service.yaml
    kubectl apply -f frontend-deployment.yaml
    kubectl apply -f frontend-service.yaml

## Access the guestbook web application

Locate one node that you frontend POD runs:

    kubectl get pods -l tier=frontend -l app=guestbook -o wide

Determine the port number of frontend service:

    kubectl get services

Then you browse the URL: http://<node_host_name_or_ip>:<port number>

[1]: https://kubernetes.io/docs/tutorials/stateless-application/guestbook/
