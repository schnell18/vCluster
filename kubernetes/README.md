# Introduction

The project sets up a 1.24.0 kubernetes cluster based on virtual machine
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
- [vagrant-hostmanager][7]
- [Ansible][3]

You also need the debian vagrant box managed by [this project][4].
It is recommended you install VS Code as you text editor.
Install these tools, and you clone this project.
Open a command line window, the nagivate to the root directory of this project.
And run the following commands:

    vagrant up
    ansible-playbook -i provision/hosts provision/playbook-master.yml
    ansible-playbook -i provision/hosts provision/playbook-node.yml
    ansible-playbook -i provision/hosts provision/playbook-dashboard.yml

Then you will be prompted to:

- run `kubectl proxy`
- open the [kubernetes dashboard][5] url
- login using the token printed on the terminal

## kubectl setup

You need install [kubectl][6] on your laptop and copy the
`/etc/kubernetes/admin.conf` from the master as `config`
under the sub directory `.kube` of you home directory.
Other tools depend on this setup.

## 1.24 compatibility issue

Since 1.24, sercet of service account is no longer created by default. You need
set the feature gate `LegacyServiceAccountTokenNoAutoGeneration` to `false` and pass
to controller-manager to get secret auto created.
You may accomplish this by specify the feature gate in kubeadm config file as:


    apiVersion: kubeadm.k8s.io/v1beta3
    kind: ClusterConfiguration
    clusterName: kubernetes
    kubernetesVersion: v1.24.0
    ...
    controllerManager:
      extraArgs:
        # auto-create secret for service account to be compatible w/ previous releases
        feature-gates: LegacyServiceAccountTokenNoAutoGeneration=false

Please be advised that for kubernetes 1.24, apiVersion must be `kubeadm.k8s.io/v1beta3`.
If you upgrade an existing kubernetes cluster to 1.24. You may change the
`/etc/kubernetes/manifests/kube-controller-manager.yaml` directly:

    metadata:
      creationTimestamp: null
      labels:
        component: kube-controller-manager
        tier: control-plane
      name: kube-controller-manager
      namespace: kube-system
    spec:
      containers:
      - command:
        - kube-controller-manager
        - --allocate-node-cidrs=true
        ...
        - --feature-gates=LegacyServiceAccountTokenNoAutoGeneration=false
        ...



[1]: https://www.virtualbox.org/
[2]: https://www.vagrantup.com/
[3]: https://www.ansible.com/
[4]: https://github.com/schnell18/vmbot/tree/master/debian
[5]: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
[6]: https://k8smeetup.github.io/docs/tasks/tools/install-kubectl/
[7]: https://github.com/devopsgroup-io/vagrant-hostmanager
