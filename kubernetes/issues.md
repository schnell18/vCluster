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

[1]: https://packages.cloud.google.com/apt/doc/apt-key.gpg
