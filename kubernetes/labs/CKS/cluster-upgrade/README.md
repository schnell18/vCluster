# Cluster upgrade

Explore how to upgrade a kubernetes cluster.

## Drives

The main drives to upgrade a kubernetes cluster are:

- integrate new features
- fix bugs
- fix security vulnerabilities

## Procedure

- upgrade the control plane
- upgrade nodes
- upgrade client such as kubectl
- adjust resource based on new kubernetes version

### Upgrade control plane w/ kubeadm

First install target version of kubeadm, run the following command on
Debian/Ubuntu to upgrade kubeadm:

    apt-mark unhold kubeadm
    apt-get install kubeadm=1.28.5-1.1
    apt-mark hold kubeadm

Then drain the master node

    kubectl drain master --ignore-daemonsets

Initiate the upgrade:

    kubeadm upgrade apply v1.28.5

Upgrade kubelet and restart kubelet service:

    apt-mark unhold kubelet kubectl
    apt-get install kubelet=1.28.5-1.1 kubectl=1.28.5-1.1
    apt-mark hold kubelet kubectl

### Upgrade work node w/ kubeadm

First, evict all work load from target node by draining the node:

    kubectl drain slave-1 --ignore-daemonsets

If there is standalone pods, then migrate them manually or just kill them with
the --force option:

    kubectl drain slave-1 --ignore-daemonsets --force

Update the OS package manager to point to the target minor version, eg to
upgrade to 1.28.x on Debian/Ubuntu, you edit the
/etc/apt/source.list.d/kubernetes to reference the 1.28 repo as follows:

    deb https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /

Then install target version of kubeadm, run the following command on
Debian/Ubuntu to upgrade kubeadm:

    apt-mark unhold kubeadm
    apt-get install kubeadm=1.28.5-1.1
    apt-mark hold kubeadm

Initiate the upgrade:

    kubeadm upgrade node

Upgrade kubelet and restart kubelet service:

    apt-mark unhold kubelet kubectl
    apt-get install kubelet=1.28.5-1.1 kubectl=1.28.5-1.1
    apt-mark hold kubelet kubectl

