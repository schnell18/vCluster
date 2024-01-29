# Unable to launch Pod with seccomp profile

Describe the failed pod reveals:

    Warning  Failed     35s (x3 over 49s)  kubelet            Error: failed to
    create containerd task: failed to create shim task: OCI runtime create
    failed: runc create failed: unable to start container process: unable to
    init seccomp: error creating filter: could not create filter: unknown

It seems to be a kernel bug as indicated by [this issue][1]. The workaroud
is to bump up `net.core.bpf_jit_limit`:

    sudo sysctl --all | grep net.core.bpf_jit_limit
    net.core.bpf_jit_limit = 264241152
    sudo cat /proc/vmallocinfo | grep bpf_jit | awk '{s+=$2} END {print s}'
    91500544

Upgrade to kernel linux-image-4.19.0-26-amd64(4.18.280+) should fix the problem.

[1]: https://github.com/moby/moby/issues/45498#issuecomment-1542155705
[2]: https://docs.google.com/document/d/1a9uUAISBzw3ur1aLQqKc5JOQLaJYiOP5pe_B4xCT1KA/edit?pli=1#heading=h.nqnduhrd5gpk
[3]: https://docs.docker.com/engine/security/seccomp/
