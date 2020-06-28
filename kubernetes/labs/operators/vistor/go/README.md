# Introduction

Simple visitor web app deployed using go operator.

## bootstrap

Grab [the kubernetes operator SDK][1] and install to a directory and make it
searchable under PATH.

Before you create the go operator, make sure you are able to access [golang.org][1],
otherwise, you use appropriate proxy such as:

    export http_proxy=socks5://127.0.0.1:1080
    export https_proxy=socks5://127.0.0.1:1080

To create the go operator, type commands as follows:

    operator-sdk new visitor-operator --repo tinkerit.cf/visitor


## Add an API


Before you create a new API, make sure the GOROOT environment varialbe
is properly set.

    export GOROOT=/usr/local/go

To add a new API, you type command as follows:

    operator-sdk add api --api-version=tinkerit.cf/v1 --kind=VisitorsApp

### regenerate after *_types.go change

If you make changes in *_types.go file, you need regenerate the go programs as follows:

    operator-sdk generate k8s


## Add a controller

Run the following command to generate skeleton code for controller:

    operator-sdk add controller --api-version=tinkeritcf/v1 --kind=VisitorsApp

## access visitor web interface

Find the ip address of the frontend service:

    FRONTEND_HOST=`kubectl get pod -l app=visitors,tier=backend -o jsonpath='{.items[0].status.hostIP}'`

Or if you have jq installed, you may better off using `jq` instead:

    FRONTEND_HOST=`kubectl get pod -l app=visitors,tier=backend -o json | jq -r '.items[0].status.hostIP'`

Open browser and navigate to http://$FRONTEND_HOST:30686/

## cleanup

To remove resources created by this lab, you type:

[1]: https://golang.org/