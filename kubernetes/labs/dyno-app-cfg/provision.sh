#!/bin/bash

# provision configuration files to each kubernetes nodes

INVETORY_FILE="../../.vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory"

HOSTS=$(cat $INVETORY_FILE | grep "^\w" | cut -d' ' -f 1)
for host in $HOSTS; do
    vagrant ssh $host -- sudo cp -r /work/labs/dyno-app-cfg/configs /var/lib
done


