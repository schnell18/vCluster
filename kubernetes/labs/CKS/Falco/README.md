# Introduction

Explore falco, a tool provides near real-time monitoring of runtime events such
as system calls to identify security bleaches.

## Installation

Debian-like systems:


    curl -fsSL https://falco.org/repo/falcosecurity-packages.asc | \
    sudo gpg --dearmor -o /usr/share/keyrings/falco-archive-keyring.gpg
    sudo bash -c 'cat << EOF > /etc/apt/sources.list.d/falcosecurity.list
    deb [signed-by=/usr/share/keyrings/falco-archive-keyring.gpg] https://download.falco.org/packages/deb stable main
    EOF'
    sudo apt-get update -y
    sudo apt-get install -y dkms make linux-headers-$(uname -r) dialog


## falco install issue on debian

The kernel version reported by `uname -r` on debian is incorrect.

    # Workaround: debian kernelreleases might now be actual kernel running;
    # instead, they might be the Debian kernel package
    # providing the compatible kernel ABI
    # See https://lists.debian.org/debian-user/2017/03/msg00485.html
    # Real kernel release is embedded inside the kernel version.

A simplest fix is to create a symbolic link with the name as Linux kernel
version, the Debian kernel ABI compatible kernel name as source:

    ln -sf /lib/modules/4.19.0-18-amd64 /lib/modules/4.19.208-1-amd64

## experiment 1 -- customize built-in rule "Terminal shell in container"

Change the built-in "Terminal shell in container" rule's priority to WARN.

Copy the definition of  "Terminal shell in container" rule in
`/etc/falco/falco_rules.yaml` to `/etc/falco/falco_rules.local.yaml`.
Change the priority to "WARNING" as follows:

    - rule: Terminal shell in container
      desc: >
        A shell was used as the entrypoint/exec point into a container with an attached terminal. Parent process may have
        legitimately already exited and be null (read container_entrypoint macro). Common when using "kubectl exec" in Kubernetes.
        Correlate with k8saudit exec logs if possible to find user or serviceaccount token used (fuzzy correlation by namespace and pod name).
        Rather than considering it a standalone rule, it may be best used as generic auditing rule while examining other triggered
        rules in this container/tty.
      condition: >
        spawned_process
        and container
        and shell_procs
        and proc.tty != 0
        and container_entrypoint
        and not user_expected_terminal_shell_in_container_conditions
      output: A shell was spawned in a container with an attached terminal (evt_type=%evt.type user=%user.name user_uid=%user.uid user_loginuid=%user.loginuid process=%proc.name proc_exepath=%proc.exepath parent=%proc.pname command=%proc.cmdline terminal=%proc.tty exe_flags=%evt.arg.flags %container.info)
      priority: WARNING
      tags: [maturity_stable, container, shell, mitre_execution, T1059]

Create a new pod using following command:

    kubectl apply -f shell-experiment.yaml

Then attach to the container as follows:

    kubectl exec -it web2 -- sh

Observe the /var/log/syslog on slave-1 to see if there is a warning message
stating "A shell was spawned ...".
