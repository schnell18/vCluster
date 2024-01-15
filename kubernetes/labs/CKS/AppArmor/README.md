# Introduction

AppArmor is a Linux kernel security module that allows system administrator to
restrict programs' capabilities such as network access, raw socket access,
access to file system etc. It has been included in the Linux kernel since
version 2.6.36 and is shipped by Debian, Ubunut and OpenSUSE.
There are three main versions of AppArmor:

- 2.x series (old but still supported)
- 3.x series (current)
- 4.x series (development)

To check if AppArmor is installed, simply run `aa-status`.
To ckeck AppArmor log, run `sudo journalctl -fx`.
AppArmor's profiles are stored under `/etc/apparmor.d/`.

## profile definition

Profiles don't provide confinement unless they are attached to a running
program. General forms of profile definitions:

    /usr/bin/curl {
        # body go here
    }

    profile name {
        # body go here
    }

## define you own profile

You can use the `apparmor-utils` to define your owner profile, for example,
the `curl` command. You first install the `apparmor-utils`:

    apt-get install -y apparmor-utils

Then you run:

    aa-genprof `which curl`

It will generate a basic profile in `/etc/apparmor.d/usr.bin.curl`:


    # Last Modified: Fri Jan 12 18:01:50 2024
    abi <abi/3.0>,

    include <tunables/global>

    /usr/bin/curl {
      include <abstractions/base>

      /usr/bin/curl mr,

    }

This profile prohibits network function, so if you run:

    curl google.com

You will get:

    curl: (6) Could not resolve host: google.com

To allow curl use network, you can aa-logprof:

    aa-logprof

And select `Allow` option.

If edit the file manually, you use `apparmor_parser` to load it into kernel:

    apparmor_parser -r /etc/apparmor.d/usr.bin.curl

Or you can reload the apparmor daemon using systemctl:

    systemctl reload apparmor.service

## Restrict kubernetes container with AppArmor

Ensure the `AppArmor` feature is not turned-off.
Determine the AppArmor profile to use:

- use `runtime/default` which is usually defined by [this template][1]
- use specific AppArmor profile which must be loaded on every node that Pod runs

Bind the profile with the per container annotation
`container.apparmor.security.beta.kubernetes.io/<container_name>` like:

    apiVersion: v1
    kind: Pod
    metadata:
      labels:
        run: confined
      name: confined
      annotations:
        container.apparmor.security.beta.kubernetes.io/confined: localhost/k8s-deny-write

## Experiment 1 - confine nginx running inside container.

Load the `containerized-nginx` profile on the host

    apparmor_parser -r /etc/apparmor.d/containerized-ngix

Run the nginx container with docker:

    docker run --name web --security-opt apparmor=containerized-nginx -d docker.io/library/nginx:1.24.0-bullseye-perl

Attach to the nginx container and try to create file and launch shells:

    docker exec -it web -- sh
    touch /root/scratch.txt
    sh

You should observe `touch: cannot touch '/root/scratch.txt': Permission denied`
and `sh: 1: sh: Permission denied`.


## Experiment 2 - confine nginx running inside kubernetes.

Load the following profile on all nodes:

    include <tunables/global>

    profile k8s-deny-write flags=(attach_disconnected) {
      include <abstractions/base>

      file,

      # Deny all file writes.
      deny /** w,
    }

Use the `load-apparmor-profile.sh` script to do so.
Create a busybox Pod restricted by the `k8s-deny-write` AppArmor profile:

    kubectl apply -f confined-busybox.yaml

Run command inside the container to read `/proc/cmdline`.

    kubectl exec confined -- cat /proc/cmdline

This command should succeed.

Run command inside the container to create a file `/tmp/venio-vinco`.

    kubectl exec confined -- touch /tmp/venio-vinco

This command should fail with `touch: /tmp/venio-vinco: Permission denied`.

[1]: https://github.com/containers/common/blob/main/pkg/apparmor/apparmor_linux_template.go
