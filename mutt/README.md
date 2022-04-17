# Introduction

The project demonstrates setting up containerized application running on CentOS 7.
Setup is automated using ansible. It contains three nodes:

- mutt1
- mutt2
- mutt3

If you wish to add more nodes, you may add nodes change `Vagrantfile` and
adjust the ansible inventory file `hosts` accordingly.

## setup procedure

You need the following tools required by this project:

- [Virtualbox][1]
- [Vagrant][2]
- [vagrant-hostmanager][3]
- [Ansible][4]

You also need the CentOS vagrant box managed by [this project][5].
Install these tools, and you clone this project.
Open a command line window, the nagivate to the root directory of this project.
And run the following commands:

    vagrant up
    ansible-playbook -i provision/hosts provision/playbook-infra.yml


## using ansible galaxy

Install docker module use ansible galaxy:

    ansible-galaxy collection install community.docker

## deploy mutt

    ansible-playbook --extra-vars "version=v0.0.1-41" -i provision/hosts provision/playbook-app.yml

## query RPM GPG public key

rpm --query gpg-pubkey | xargs rpm --query gpg-pubkey --queryformat "%{NAME}-%{VERSION}-%{RELEASE}\n\tSUMMARY: %{SUMMARY}\n\tPACKAGER: %{PACKAGER}\n\tINSTALL TIME: %{INSTALLTIME:date}\n"

[1]: https://www.virtualbox.org/
[2]: https://www.vagrantup.com/
[3]: https://github.com/devopsgroup-io/vagrant-hostmanager
[4]: https://www.ansible.com/
[5]: https://github.com/schnell18/vmbot/tree/master/centos
