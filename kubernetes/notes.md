## debug libvirt

    sudo virt-admin -c virtqemud:///system daemon-log-outputs "3:journald 1:file:/var/log/libvirt/libvirtd.log"
    sudo virt-admin -c virtqemud:///system daemon-log-filters "3:remote 4:event 3:util.json 3:util.object 3:util.dbus 3:util.netlink 3:node_device 3:rpc 3:access 1:*"
    sudo virt-admin -c virtqemud:///system daemon-timeout 0

## libvirt vm paused

The 'paused' state of a VM can be attributed to a multitude of factors.
However, a common cause that is often overlooked is disk space availability.
Insufficient free disk space can force a VM into a 'paused' state as a
protective measure to avoid potential data loss or corruption.

## permission issue of libvirt storage pool under $HOME directory

Make sure the directory of the storage pool is readable, writable and
executable to the `libvirt-qemu` group. And all its parents up to the $HOME
directory are readable and executable to the `libvirt-qemu` group.
You can setup the permission using the `setfacl` command as follows:

    sudo setfacl -m u:libvirt-qemu:rx /home/justin
    sudo setfacl -m u:libvirt-qemu:rx /home/justin/.local
    sudo setfacl -m u:libvirt-qemu:rx /home/justin/.local/state
    sudo setfacl -m u:libvirt-qemu:rwx /home/justin/.local/libvirt

And check the permission as:

    sudo getfacl -e /home/justin
    sudo getfacl -e /home/justin/.local/libvirt

Reference [Cannot access storage file, Permission denied Error in KVM Libvirt][1].

## calico cni plugin install fail issue

Error message:

    2024-01-18T17:41:12.106704879Z stderr F 2024-01-18 17:41:12.106 [WARNING][1] cni-installer/<nil> <nil>: Neither --kubeconfig nor --master was specified.  Using the inClusterConfig.  This might not work.
    2024-01-18T17:41:42.133777272Z stderr F 2024-01-18 17:41:42.133 [ERROR][1] cni-installer/<nil> <nil>: Unable to create token for CNI kubeconroot@master:/var/log/containers

[Create a kubeconfig for calico CNI][2]

## debug bash script

[debug bash script][3]

[1]: https://ostechnix.com/solved-cannot-access-storage-file-permission-denied-error-in-kvm-libvirt/
[2]: https://docs.tigera.io/calico/latest/getting-started/kubernetes/hardway/install-cni-plugin
[3]: https://www.baeldung.com/linux/debug-bash-script
