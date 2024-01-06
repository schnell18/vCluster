# Introduction

Explores micro-service mTLS.

## trick to create template of pod

    kubectl run ping --image=ubuntu:noble --command -o yaml --dry-run=client > ping.yaml -- sh -c 'ping google.com'

## springboot + redis demo application using mTLS

This demo is based [a tanzu example][1].

Request springboot http service:

    kubectl -n mtls-demo debug \
        it spring-boot-redis-client-app-xxxxxxxxxx-xxxxx \
        --image=docker.io/library/bash:5 \
        --target=spring-boot-redis-client-app

Then run:

    apk add curl && curl localhost:8080

inside the shell. You should see a UUID is returned.

Alternatively, you may use the port-forward feature of kubectl as follows:

    kubectl port-forward svc/spring-boot-redis-client-app 8080:8080 -n mtls-demo
    curl -XGET http://localhost:8080/

## enable mTLS
### install cert-manager

    kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.3/cert-manager.yaml

[1]: https://tanzu.vmware.com/developer/guides/kubernetes-mtls/
