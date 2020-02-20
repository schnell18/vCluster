# Introduction

This is a practice to create simple statefulset managing nginx.

## Deployment instructions

The nginx pod requires a persistent volume. You need provision the PV
manually by typing the command as follows:

    kubectl apply -f local-pv.yaml

Then you create the nginx statefulset by running:

    kubectl apply -f nginx.yaml

## scale up

Before scale up, you need create 3 extra PVs.
Run the following command to watch the nginx pods:

    kubectl get pods -w app=nginx

Scale up by:

    kubectl scale sts web --replicas=5

## write to storage

Write host name to index.html:

    for i in 0 4; do
        kubectl exec web-$i -- sh -c 'echo $(hostname) > /usr/share/nginx/html/index.html';
    done

    for i in 0 4; do
        kubectl exec -it web-$i -- curl localhost;
    done
