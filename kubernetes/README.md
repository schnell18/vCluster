# Introduction

The project sets up a kubernetes cluster based on virtual machine managed by
vagrant and ansible. It is intended for research use on personal computer. By
default it creates a cluster containing the following nodes:

- master
- slave-1
- slave-2
- slave-3
- slave-4


If you wish to add more nodes, you may add nodes by changing `Vagrantfile`.

## setup procedure

You need the following tools required by this project:

- [Virtualbox][1](Windows/MacOS) or libvirt(Linux )
- [Vagrant][2]
- [vagrant-hostmanager][7]
- [Ansible][3]

Although VirtualBox also works on Linux, it is recommended use libvirt as it is
more efficient. Install these tools using package manager of operating systems for
instance use apt-get on Debian/Ubuntu. To install vagrant-hostmanager, you
type:

    vagrant plugin install vagrant-hostmanager

On Linux, if you use libvirt, you need the `vagrant-libvirt` plugin, which can
installed as follows:

    vagrant plugin install vagrant-libvirt

Then you clone this project. Open a command line window, the nagivate to the
root directory of this project. And run the following commands if you use
VirtualBox:

    vagrant up

Otherwise, run this command instead: 

    vagrant up --provider=libvirt --no-parallel

The two arguments are mandatory. If everything goes smoothly, the master and
work nodes will be installed and configured automatically. You should get an
operational kubernetes cluster at this point. Optionally, you can install the
dashboard for kubernetes by executing the command as follows:

    ansible-playbook \
        -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory \
        provision/playbook-dashboard.yml

When you will be prompted to:

- run `kubectl proxy`
- open the [kubernetes dashboard][5] url
- login using the token printed on the terminal

In case the provision of master fails, you may trigger the setup by:

    ansible-playbook \
        -e hypervisor=libvirt \
        -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory \
        provision/playbook-master.yml

Likewise, if the provision of work node fails for reasons such as network
connectivity, you may re-run ansible as follows:

    ansible-playbook \
        -e hypervisor=libvirt \
        -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory \
        provision/playbook-node.yml

For VirtualBox backend, you remove the `-e hypervisor=libvirt ` argument.

## kubectl setup

You need install [kubectl][6] on your laptop and copy the
`/tmp/kubeconfig.conf`, which is feteched from the master node, as `config`
under the sub directory `.kube` of you home directory. Other tools depend on
this setup.

[1]: https://www.virtualbox.org/
[2]: https://www.vagrantup.com/
[3]: https://www.ansible.com/
[4]: https://github.com/schnell18/vmbot/tree/master/debian
[5]: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
[6]: https://k8smeetup.github.io/docs/tasks/tools/install-kubectl/
[7]: https://github.com/devopsgroup-io/vagrant-hostmanager
[8]: https://kubernetes.io/blog/2023/03/10/image-registry-redirect/
[9]: https://kubernetes.io/blog/2023/08/31/legacy-package-repository-deprecation/
