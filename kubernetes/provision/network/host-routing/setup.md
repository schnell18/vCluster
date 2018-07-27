# setup routing to POD on MacOS X

You need setup ip forward and add routing to pod and make MacOS X aware of
kube-dns.

## Enable IP forward

To enable IP forward on MacOS X, you run the command that follows:

    sudo sysctl -w net.inet.ip.forwarding=1

## add IP route to Pod

You may get POD CIDR on each node, and add routing manully as follow:

    sudo route add -net 10.200.145.192/26 192.168.90.26

## config MacOS X to use kube-dns

Some service should best be accessed by DNS, for instance the stateful set.
Kubernetes managed services are usually sub-domain of cluster.local. So you
can instruct MacOS X to recognize kube-dns by creating the /etc/resolver/cluster.local file.
The you put:

    domain cluster.local
    nameserver <IP_ADDRESS_OF_KUBE_DNS_SERVER>

into this file.

## validate Pod is accessible from host

Run this command to validate:

    kubectl get pod -o jsonpath='{.items[*].status.podIP}' | xargs fping