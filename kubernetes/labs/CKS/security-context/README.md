# Introduction

Explores security context to run container with least privilege.

## run a noop shell

    kubectl run noop-shell --image=docker.io/library/busybox --dry-run=client -o yaml -- sh -c 'sleep 1d' > noop-shell.yaml
