# issue of setting up kubernetes

## privileged container fail to start

    pod cannot be run: pod with UID "660803e5-71fa-11e8-8959-0800272b122e" specified privileged container, but is disallowed

To fix this add --allow-privileged to kubelet startup command line.
See also [Cannot deploy pod with securityContext privileged=true][1]

## gcr.io firewalled

To work around this, we configure containerd to use http proxy through
environment variable like:

    cat << EOF > $CONTAINERD_CONF_DIR/env.lst
    HTTP_PROXY=192.168.90.1:1087
    HTTPS_PROXY=192.168.90.1:1087
    NO_PROXY=docker-cn.com
    EOF

then in containerd's systemd unit file we add:

    cat << EOF > /etc/systemd/system/containerd.service
    [Unit]
    Description=containerd container runtime
    Documentation=https://containerd.io
    After=network.target

    [Service]
    EnvironmentFile=$CONTAINERD_CONF_DIR/env.lst
    ExecStartPre=/sbin/modprobe overlay
    ExecStart=/usr/local/bin/containerd
    Restart=always
    RestartSec=5
    Delegate=yes
    KillMode=process
    OOMScoreAdjust=-999
    LimitNOFILE=1048576
    LimitNPROC=infinity
    LimitCORE=infinity

    [Install]
    WantedBy=multi-user.target
    EOF

The other solution is to pre download the gcr images and load them manually.

    images=(                             \
      pause-amd64:3.1                    \
      kubernetes-dashboard-amd64:v1.8.3  \
      k8s-dns-sidecar-amd64:1.14.8       \
      k8s-dns-kube-dns-amd64:1.14.8      \
      k8s-dns-dnsmasq-nanny-amd64:1.14.8 \
    )
    for imageName in ${images[@]} ; do
      docker pull anjia0532/$imageName
      docker tag anjia0532/$imageName k8s.gcr.io/$imageName
      docker rmi anjia0532/$imageName
    done

    docker save xxx  > images.tar

    ctr cri load images.tar

## helm install stable/redis failure

Kubernete 1.10.2 + containerd 1.1.0 gives:

    EACCES: permission denied, open '/.nami/registry.json'

Also reported by [Helm deployment container permissions issues with Redis][2]

## calico fail to startup

    2018-06-23 15:56:59.682 [FATAL][1] main.go 81: Failed to start error=failed to build Calico client: could not initialize etcdv3 client: asn1: structure error: tags don't match (16 vs {class:0 tag:2 length:1 isCompound:false}) {optional:false explicit:false application:false defaultValue:<nil> tag:<nil> stringType:0 timeType:0 set:false omitEmpty:false} tbsCertificate @2

This is mis-configuration issue by mistake key file as ca file.

## incorrect nameserver IP address

    12s		12s		1	kubelet, kbn3.kube.vn	spec.containers{busybox}	Warning		Failed			Failed to pull image "busybox": rpc error: code = Unknown desc = failed to resolve image "docker.io/library/busybox:latest": failed to do request: Head https://registry.docker-cn.com/v2/library/busybox/manifests/latest: dial tcp: lookup registry.docker-cn.com on 10.0.2.3:53: read udp 10.0.2.15:39203->10.0.2.3:53: i/o timeout

The fix is to turn on virtualbox's host resolver like:

    VBoxManage modifyvm "VM name" --natdnshostresolver1 on

With vagrant you can:

     kbn.vm.provider "virtualbox" do |vb|
        vb.name   = node_id
        vb.gui    = false
        vb.memory = 1024
        vb.cpus   = 2
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

[Also reported by this post][3]

[1]: https://github.com/rancher/rancher/issues/12600
[2]: https://github.com/bitnami/bitnami-docker-redis/issues/100
[3]: https://serverfault.com/questions/453185/vagrant-virtualbox-dns-10-0-2-3-not-working
