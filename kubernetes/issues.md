# Introduction

Record issues and problems found during setup kubernetes cluster on
virtual machines.

## convert gpg binary to ascii format

The gpg key from google[1] is in binary format. Convert it to ascii format
is good for setup automation. The procedure is as follows:

* import .gpg file -- gpg --import <file>
* export use -a -- gpg --export -a >  <file>.asc

## jinja2 template curly brace

Got error like:

    fatal: [node-1.kube.vn]: FAILED! => {"msg": "An unhandled exception occurred while running the lookup plugin 'template'. Error was a <class 'ansible.errors.AnsibleError'>, original message: template error while templating string: unexpected '.'. String: found=$(docker images --format \"{{.Repository}}\" | grep kube-apiserver)\nif [ -z $found ]; then\n    docker load < /work/.preload/k8s-meta-images.tar\n    if [ $? -eq 0 ]; then\n        echo \"Loaded k8s meta images\"\n    else\n        echo \"Fail to k8s meta images!!!\"\n        exit 1\n    fi\nfi\n"}
    fatal: [node-2.kube.vn]: FAILED! => {"msg": "An unhandled exception occurred while running the lookup plugin 'template'. Error was a <class 'ansible.errors.AnsibleError'>, original message: template error while templating string: unexpected '.'. String: found=$(docker images --format \"{{.Repository}}\" | grep kube-apiserver)\nif [ -z $found ]; then\n    docker load < /work/.preload/k8s-meta-images.tar\n    if [ $? -eq 0 ]; then\n        echo \"Loaded k8s meta images\"\n    else\n        echo \"Fail to k8s meta images!!!\"\n        exit 1\n    fi\nfi\n"}
            to retry, use: --limit @/mnt/d/work/infra/vCluster/altk9/provision/playbook-node.retry

This is caused by the {{.Repository}} is not escaped properly. Solution is to enclose
this {{.Repository}} inside a {% raw %} and {% endraw %} block.

## kubernetes-dashboard pod crashes

    2019/04/01 16:12:55 Error while initializing connection to Kubernetes apiserver. This most likely means that the cluster is misconfigured (e.g., it has invalid apiserver certificates or service account's configuration) or the --apiserver-host param points to a server that does not exist. Reason: Get https://10.96.0.1:443/version: dial tcp 10.96.0.1:443: i/o timeout
    Refer to our FAQ and wiki pages for more information: https://github.com/kubernetes/dashboard/wiki/FAQ

Caused by self-signed api-server certificate not trusted by the kubernetes-dashboard pod. Copy the CA certificate genereated by
kubeadm to OS level, and use curl to verify:

    mkdir -p /usr/local/share/ca-certifcates/kubernetes
    cp /etc/kubernetes/pki/ca.crt /usr/local/share/ca-certificates/kubernetes
    update-ca-certificates
    curl -v https://kubernetes.local/version

 However this method does not apply to kubernetes-dashboard as it runs inside
container. 

 However, schedule kubernetes-dashboard pod to the master node where the api-server runs solve the problem.
To force the kubernetes-dashboard run on master node, we can add a label to master node

    kubectl label node master dashboard=true

 and use nodeSelector to ask kubernetes to run the dashboard on the same node as the api server:

      nodeSelector:
         dashboard: "true"


# kubernetes 1.17.1 warning

kubernetes 1.17.1 w/ docker 19 ce

    [preflight] Running pre-flight checks
        [WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd". Please follow the guide at https://kubernetes.io/docs/setup/cri/

[1]: https://packages.cloud.google.com/apt/doc/apt-key.gpg
