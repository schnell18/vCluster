# Introduction

Explore secure computing of Linux kernel.

Seccomp stands for secure computing mode which is a security facility in the
Linux kernel. Seccomp allows a process to make a one-way transition into a
secure state where no system calls except exit, sigreturn, read and write to
already-opened file descriptors are allowed, thus creating an isolated sandbox
to insulate potentially harmful process. Seccomp is a kernel feature since
2.6.12.

Seccomp profiles are defined in JSON format. A mininal profile example is as
follows:

    {
        "defaultAction": "SCMP_ACT_LOG"
    }

It doesn't prevent any violation of rules, it just log the events. The hard
part of defining a Seccomp profile is to minimize the privileges required by
the process.

In order to use Seccomp profiles with Kubernetes, you must upload the profiles
JSON files to the directory recognized by kubelet, usually
`/var/lib/kubelet/seccomp`. There are two ways to do so:

- use an init-contaier to copy the profile inside the image to host path, as
  demonstrated by [this article][1]
- prefine the necessary Seccomp profiles and provision to the nodes

## Experiment preparation

## Experiment 1 - audit system calls

Run the following command to create a pod with auditing only:

    kubectl apply -f audit-pod.yaml

Expose the pod to localhost so that we can make HTTP request to it:

    kubectl port-forward pod/audit-pod 8080:80

In a second terminal find the worker node of the pod:

    kubectl get pods audit-pod -o wide

Logon the worker node and execute:

    sudo journalctl -f | grep audit | grep SECCOMP

In a third terminal, make a request with curl:

    curl localhost:8080

You should see the a few log messages scroll over the second terminal.
Key information includes:

- exe=/usr/sbin/nginx
- syscall=n

where `n` is a number representing the syscall. In the case of nginx to
to serve a simple home page query, it invokes the following syscalls:

- accept4(288)
- close(3)
- epoll\_ctl(233)
- epoll\_wait(232)
- fstat(5)
- openat(257)
- recvfrom(45)
- sendfile(40)
- setsockopt(54)
- stat(4)
- write(1)
- writev(20)

## Experiment 2 - block system calls

Run the following command to create a pod with auditing only:

    kubectl apply -f violation-pod.yaml

In a second terminal find the worker node of the pod:

    kubectl get pods violation-pod -o wide

The pod is stuck in the `CrashLoopBackOff` forever.

## Experiment 3 - fine-grained seccomp profile

Run the following command to create a pod with auditing only:

    kubectl apply -f finegrained-pod.yaml

Expose the pod to localhost so that we can make HTTP request to it:

    kubectl port-forward pod/audit-pod 8080:5678

In a second terminal, make a request with curl:

    curl localhost:8080

You should observe the following output:

    just made some syscalls!

## Reference material

The [Kubernetes Seccomp Profiles: A Practical Guide][2] by pulumi is of good quality.
And [Docker's default profile][3] is worth looking into.

[1]: https://solureal.com/blogs/create-seccomp-profile-on-managed-kubernetes-clusters
[2]: https://www.pulumi.com/resources/kubernetes-seccomp-profiles/
[3]: https://raw.githubusercontent.com/docker/labs/master/security/seccomp/seccomp-profiles/default.json
