# Introduction

This document explains to deploy an application using ArgoCD.

## deploy guestbook sample application

Create the guestbook application using ArgoCD CLI or UI.

    argocd app create guestbook \
           --repo https://github.com/argoproj/argocd-example-apps.git \
           --path guestbook \
           --dest-server https://kubernetes.default.svc \
           --dest-namespace default
