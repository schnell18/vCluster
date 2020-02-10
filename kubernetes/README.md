# Introduction

The project sets up a 1.17.1 kubernetes cluster based on virtual machine
managed by vagrant and ansible. It is intended for research use on personal
computer. By default it creates a cluster containing:

- master
- slave-1
- slave-2
- slave-3

If you wish to add more nodes, you may add nodes change `Vagrantfile` and
adjust the ansible inventory file `hosts` accordingly.

## setup procedure

You need the following tools required by this project:

- [Virtualbox][1]
- [Vagrant][2]
- [Ansible][3]

You also need the debian vagrant box build by [this project][4].
It is recommended you install VS Code as you text editor.
Install these tools, and you clone this project.
Open a command line window, the nagivate to the root directory of this project.
And run the following commands:

    vagrant up
    ansible-playbook -i hosts provision/playbook-master.yml
    ansible-playbook -i hosts provision/playbook-node.yml

Then you will be prompted to:

- run `kubectl proxy`
- open the [kubernetes dashboard][5] url
- login using the token printed on the terminal

## kubectl setup

You need install [kubectl][6] on your laptop and copy the
`/etc/kubernetes/admin.conf` from the master as `config`
under the sub directory `.kube` of you home directory.
Other tools depend on this setup.

## proxy issue

For well-known reason, people from China need proxy to access google
docker image registry and apt packages. This project helps to workaround
these issues. You may preload the gcr meta images by save them into a file
call `k8s-meta-images.tar` and put it under the .preload directory. Ansible
will automatically load these images into master as well as any node.

Here is the script to make the so-called `k8s-meta-images.tar`:

    docker save \
      calico/node:v3.12.0 \
      calico/pod2daemon-flexvol:v3.12.0 \
      calico/cni:v3.12.0 \
      calico/kube-controllers:v3.12.0 \
      k8s.gcr.io/kube-apiserver:v1.17.1 \
      k8s.gcr.io/kube-controller-manager:v1.17.1 \
      k8s.gcr.io/kube-scheduler:v1.17.1 \
      k8s.gcr.io/kube-proxy:v1.17.1 \
      k8s.gcr.io/coredns:1.6.5 \
      k8s.gcr.io/etcd:3.4.3-0 \
      k8s.gcr.io/kube-proxy:v1.14.2 \
      k8s.gcr.io/kube-apiserver:v1.14.2 \
      k8s.gcr.io/kube-controller-manager:v1.14.2 \
      k8s.gcr.io/kube-scheduler:v1.14.2 \
      k8s.gcr.io/kubernetes-dashboard-amd64:v1.10.1 \
      k8s.gcr.io/pause:3.1 > meta-images.tar


[1]: https://www.virtualbox.org/
[2]: https://www.vagrantup.com/
[3]: https://www.ansible.com/
[4]: https://github.com/schnell18/vmbot/tree/master/debian
[5]: http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
[6]: https://k8smeetup.github.io/docs/tasks/tools/install-kubectl/ 
