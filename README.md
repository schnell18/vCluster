# Introduction

Collections of software defined virtual environments. Each module is managed by
either vagrant or lima. For vagrant managed module, the vagrant box is built
from minimal CentOS or Debian images which is the result of [the vmbot github
project][1]

## Soft cluster catalog

| Folder         | Version       | Nodes          | root password | type      |
| -------------- | ------------- | -------------- | ------------- | --------- |
| zookeeper      | 3.48          | zk1,zk2,zk3    | root          | vagrant   |
| kafka          | 0.10.1.0      | kf1,kf2,kf3    | root          | vagrant   |
| elasticsearch  | 5.0.0         | es1,es2,es3    | root          | vagrant   |
| hadoop         | 2.7.1         | hp1,hp2,hp3    | root          | vagrant   |
| kubernetes     | 1.18.0        | master,slave1-4| root          | vagrant   |
| lima/archlinux | rolling       | master         |               | lima      |
| lima/k8s       | 1.32          | master         |               | lima      |

## Using the vagrant managed clusters

To use the cluster, you need install [virtualbox][2], [vagrant][3] and
[vagrant-hostmanager][4]. Then clone this repository and choose the
appropriate module and type command like:

    vagrant up

under the corresponding directory and the cluster will start up in a few
mintues.

## Using the lima managed virtual machines

[Lima][5] is a lighter management tool that wraps OS-native virtualization
solution. Please install lima as follows:

    brew install lima

[1]: https://github.com/schnell18/vmbot.git
[2]: https://www.virtualbox.org/
[3]: https://www.vagrantup.com/
[4]: https://github.com/devopsgroup-io/vagrant-hostmanager
[5]: https://lima-vm.io/
