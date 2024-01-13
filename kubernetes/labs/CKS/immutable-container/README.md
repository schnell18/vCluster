# Introduction

Explore immutable container.
- remove shell
- make file system read-only
- run as non-root user

## remove shells

For new application, we can build the image without shell by using base
image such as [distroless][1].

If the container image already has shell built-in, then we can use
Pod's [StartupProbe][2] to rm the shell.

### Experiment 1: remove shells in the httpd:2.4.58 container

Launch the httpd container using:

    kubectl apply -f no-shell-startup-probe.yaml

Attach to this pod using:

    kubectl exec -it no-shell -- sh

You should encounter errors like:

    error: Internal error occurred: error executing command in container: failed to exec in container: failed to start exec "ced262ac9a3b6734598894d2067cad04952c3d6431a13bee6c2d29a74359e159": OCI runtime exec failed: exec failed: unable to start container process: exec: "sh": executable file not found in $PATH: unknown

## make file system read-only

We can make the root file system in the container readonly by declaring
securityContext's readOnlyRootFilesystem to true. However, we should
use volumes to store application state and temporary data such as logs.

### Experiment 2: remove shells in the httpd:2.4.58 container

Launch the httpd container using:

    kubectl apply -f readonly-fs.yaml

Attach to this pod using:

    kubectl exec readonly -- sh -c 'touch /touch-it'

You should get:

    touch: cannot touch '/touch-it': Read-only file system
    command terminated with exit code 1

Launch a debug container to issue an HTTP request w/ curl:

    kubectl debug -it readonly --image=docker.io/alpine:3.19.0 --target=readonly

In the shell, run the following command:

    apk add curl
    curl -v localhost

You should get "It works!"


[1]: https://github.com/GoogleContainerTools/distroless
[2]: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/#define-startup-probes

