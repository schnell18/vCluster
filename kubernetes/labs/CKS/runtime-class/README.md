# Introduction

Apply runtime class to secure container.
RuntimeClass is a non-namespaced resource which applies to cluster wide.

Procedures to use RuntimeClass:

- config CRI runtimes
- define RuntimeClass
- apply to Pod

## config CRI runtimes

### containerd setup

Modify the file `/etc/containerd/config.toml` to add:

    # gVisor: https://gvisor.dev/
    [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.gvisor]
      runtime_type = "io.containerd.runsc.v1"
    # Kata Containers: https://katacontainers.io/
    # [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.kata]
    #   runtime_type = "io.containerd.kata.v2"

And [install gvisor][1].

## define RuntimeClass

A minimal RuntimeClass is as follows:

    apiVersion: node.k8s.io/v1
    kind: RuntimeClass
    metadata:
      # The name the RuntimeClass will be referenced by.
      # RuntimeClass is a non-namespaced resource.
      name: myclass
    # The name of the corresponding CRI configuration
    handler: myconfiguration

gVisor RuntimeClass is as follows:

    apiVersion: node.k8s.io/v1
    kind: RuntimeClass
    metadata:
      name: gvisor
    handler: runsc

## apply RuntimeClass to Pod

Set the spec.runtimeClassName field:

    apiVersion: v1
    kind: Pod
    metadata:
      name: mypod
    spec:
      runtimeClassName: myclass
      # ...


[1]: https://gvisor.dev/docs/user_guide/install/
