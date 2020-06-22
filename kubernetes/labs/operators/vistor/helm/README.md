# Introduction

Simple visitor web app deployed using helm operator.

## bootstrap

Grab [the kubernetes operator SDK][1] and install to a directory and make it
searchable under PATH.

Grab [helm binary][2] and install to a directory and make it
searchable under PATH.

To create the helm operator, type commands as follows:

    operator-sdk new visitor-helm-operator \
      --api-version=example.com/v1 \
      --kind=VisitorsApp \
      --type=helm \
      --helm-chart=./visitors-helm


## run helm operator out of kubernetes cluster

Type commands as follows:

    cd vistor-helm-operator
    operator-sdk run local


## deploy vistor application

Type commands as follows:

    cd vistor-helm-operator/deploy/crds
    kubectl apply -f example.com_v1_vistorsapp_cr.yaml

## access visitor web interface

Find the ip address of the frontend service:

    FRONTEND_HOST=`kubectl get pod -l app=visitors,tier=backend -o jsonpath='{.items[0].status.hostIP}'`

Or if you have jq installed, you may better off using `jq` instead:

    FRONTEND_HOST=`kubectl get pod -l app=visitors,tier=backend -o json | jq -r '.items[0].status.hostIP'`

Open browser and navigate to http://$FRONTEND_HOST:30686/

## cleanup

To remove resources created by this lab, you type:

    cd vistor-helm-operator/deploy/crds
    kubectl delete -f example.com_v1_vistorsapp_cr.yaml

    cd vistor-helm-operator
    # stop operator-sdk

[1]: https://github.com/operator-framework/operator-sdk/releases
[2]: https://github.com/helm/helm/releases/latest