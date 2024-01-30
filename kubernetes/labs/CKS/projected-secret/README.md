# Introduction

Explore [projected secret][1].

Create a secret with two keys. Project one key to a customized path.
Examine whether the other key is mounted in the container.

## Experiment 1 -- project secret key

Create a secret and pod to use it as follows:

    kubectl apply -f use-projected-secret.yaml

Examine the log of the pod `projected-secret-pod`:

    kubectl logs projected-secret-pod

You should observe something similar to:

    Gutten Tag
    /etc/foo/
    /etc/foo/my-group
    /etc/foo/..data
    /etc/foo/..2024_01_30_04_14_29.1037720589
    /etc/foo/..2024_01_30_04_14_29.1037720589/my-group
    /etc/foo/..2024_01_30_04_14_29.1037720589/my-group/my-username

As indicated by the log, the other key `password` is not mounted into the
container.

[1]: https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/#project-secret-keys-to-specific-file-paths
