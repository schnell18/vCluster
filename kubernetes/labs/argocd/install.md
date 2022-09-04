# Introduction

This documents explains how to install argocd.


## Create namespace

    kubectl create namespace argocd

## Create argo API objects

    kubectl apply -f install.yaml -n argocd

## Access admin -

Use loaderbalancer or ingress to route traffic to argocd-server.

If you run kubernetes on your laptop, you may port-forward the argocd-server service like:

    kubectl port-forward svc/argocd-server -n argocd 8080:443

Then you can open the admin UI at localhost:8080.

The login name is `admin` while the password is stored in the secret `argocd-initial-admin-secret`.
Type the following command to retrieve the password:

    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d; echo

