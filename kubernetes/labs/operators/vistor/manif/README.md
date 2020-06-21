# Introduction

Simple visitor web app deployed using kubernetes manifest.

## deploy mysql

Type commands as follows:

    kubectl apply -f mysql/secret.yaml
    kubectl apply -f mysql/deployment.yaml
    kubectl apply -f mysql/service.yaml

## deploy backend

Type commands as follows:

    kubectl apply -f backend/deployment.yaml
    kubectl apply -f backend/service.yaml


## deploy frontend

Type commands as follows:

    kubectl apply -f frontend/deployment.yaml
    kubectl apply -f frontend/service.yaml

## access visitor web interface

Find the ip address of the frontend service:

    FRONTEND_HOST=`kubectl get pod -l app=visitors,tier=backend -o jsonpath='{.items[0].status.hostIP}'`

Or if you have jq installed, you may better off using `jq` instead:

    FRONTEND_HOST=`kubectl get pod -l app=visitors,tier=backend -o json | jq -r '.items[0].status.hostIP'`

Open browser and navigate to http://$FRONTEND_HOST:30686/

## cleanup

To remove resources created by this lab, you type:

    kubectl delete -f mysql/secret.yaml
    kubectl delete -f mysql/deployment.yaml
    kubectl delete -f mysql/service.yaml
    kubectl delete -f backend/deployment.yaml
    kubectl delete -f backend/service.yaml
    kubectl delete -f frontend/deployment.yaml
    kubectl delete -f frontend/service.yaml