# Introduction

Simple visitor web app deployed using ansible operator.

## bootstrap

Grab [the kubernetes operator SDK][1] and install to a directory and make it
searchable under PATH.

To create the ansible operator, type commands as follows:

    operator-sdk new visitor-ansible-operator \
      --api-version=example.com/v1 \
      --kind=VisitorsApp \
      --type=ansible


## run ansible operator out of kubernetes cluster

Type commands as follows:

    cd vistor-ansible-operator
    operator-sdk run local


## deploy vistor application

Type commands as follows:

    cd vistor-ansible-operator/deploy/crds
    kubectl apply -f example.com_v1_vistorsapp_cr.yaml

## access visitor web interface

Find the ip address of the frontend service:

    FRONTEND_HOST=`kubectl get pod -l app=visitors,tier=backend -o jsonpath='{.items[0].status.hostIP}'`

Or if you have jq installed, you may better off using `jq` instead:

    FRONTEND_HOST=`kubectl get pod -l app=visitors,tier=backend -o json | jq -r '.items[0].status.hostIP'`

Open browser and navigate to http://$FRONTEND_HOST:30686/

## cleanup

To remove resources created by this lab, you type:

    cd vistor-ansible-operator/deploy/crds
    kubectl delete -f example.com_v1_vistorsapp_cr.yaml

    cd vistor-ansible-operator
    # stop operator-sdk

[1]: https://github.com/operator-framework/operator-sdk/releases
[2]: https://github.com/ansible/ansible/releases/latest