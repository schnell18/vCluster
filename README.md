Introduction
============

Collections of software defined virtual cluster environments for
distributed applications. Each module includes a Vagrantfile defining
the virtualized environments to run the distributed application. The
vagrant box is built from a minimal CentOS 6 image. The exact
instructions to build this box are located at [the vmbot github
project][1]

Soft cluster catalog
====================

| Type           | Version       | Nodes          | root password | comment   |
| -------------- | ------------- | -------------- | ------------- | --------- |
| zookeeper      | 3.48          | zk1,zk2,zk3    | root          |           |
| kafka          | 0.10.1.0      | kf1,kf2,kf3    | root          |           |
| elasticsearch  | 5.0.0         | es1,es2,es3    | root          |           |
| hadoop         | 2.7.1         | hp1,hp2,hp3    | root          |           |
| kubernetes     | 1.17.1        | master,slave1-3| root          |           |

Using the cluster
=================
To use the cluster, you need install [virtualbox][2], [vagrant][3] and
[vagrant-hostmanager][4]. Then clone this repository and choose the
appropriate module and type command like:

    vagrant up

under the corresponding directory and the cluster will start up in a few
mintues.

[1]: https://github.com/schnell18/vmbot.git
[2]: https://www.virtualbox.org/
[3]: https://www.vagrantup.com/
[4]: https://github.com/devopsgroup-io/vagrant-hostmanager
