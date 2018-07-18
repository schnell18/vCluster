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

## connect to pod on other node fails

Root cause is the host node is not configured to forward IP packet as routers do.
Route table in container:

    # ip route show
    default via 169.254.1.1 dev eth0 
    169.254.1.1 dev eth0 scope link 

Route table on host node:

    [root@kbn3 ~]# ip route
    default via 10.0.2.2 dev enp0s3 proto static metric 100 
    10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100 
    10.200.42.64/26 via 192.168.90.25 dev enp0s8 proto bird 
    blackhole 10.200.115.128/26 proto bird 
    10.200.115.131 dev cali472eedd090c scope link 
    10.200.115.132 dev cali1ed9954a6a5 scope link 
    10.200.145.192/26 via 192.168.90.26 dev enp0s8 proto bird 
    192.168.90.0/24 dev enp0s8 proto kernel scope link src 192.168.90.27 metric 100 

IP forward setting:

    [root@kbn3 ~]# cat /proc/sys/net/ipv4/ip_forward
    0

Temporary fix:

    echo echo 1 > /proc/sys/net/ipv4/ip_forward

Permenant fix:

    cat <<EOF > /etc/sysctl.d/k8s.conf
    net.ipv4.ip_forward = 1
    EOF

## dashboard startup failure due to root ca absent

    2018/07/11 15:34:35 Error while initializing connection to Kubernetes apiserver. This most likely means that the cluster is misconfigured (e.g., it has invalid apiserver certificates or service accounts configuration) or the --apiserver-host param points to a server that does not exist. Reason: Get https://192.168.90.15:6443/version: x509: failed to load system roots and no roots provided
    Refer to our FAQ and wiki pages for more information: https://github.com/kubernetes/dashboard/wiki/FAQ

This is caused by not load the root ca certificates in /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem on RHEL7/CentOS7

## dashboard startup failure due to problematic root ca

    2018/07/17 16:36:04 Synchronizer kubernetes-dashboard-key-holder-kube-system exited with error: unexpected object: &Secret{ObjectMeta:k8s_io_apimachinery_pkg_apis_meta_v1.ObjectMeta{Name:,GenerateName:,Namespace:,SelfLink:,UID:,ResourceVersion:,Generation:0,CreationTimestamp:0001-01-01 00:00:00 +0000 UTC,DeletionTimestamp:<nil>,DeletionGracePeriodSeconds:nil,Labels:map[string]string{},Annotations:map[string]string{},OwnerReferences:[],Finalizers:[],ClusterName:,Initializers:nil,},Data:map[string][]byte{},Type:,StringData:map[string]string{},}
    2018/07/17 16:36:05 Storing encryption key in a secret
    panic: secrets is forbidden: User "system:anonymous" cannot create secrets in the namespace "kube-system"

    goroutine 1 [running]:
    github.com/kubernetes/dashboard/src/app/backend/auth/jwe.(*rsaKeyHolder).init(0xc420206fa0)
        /home/travis/build/kubernetes/dashboard/.tmp/backend/src/github.com/kubernetes/dashboard/src/app/backend/auth/jwe/keyholder.go:131 +0x2d3
    github.com/kubernetes/dashboard/src/app/backend/auth/jwe.NewRSAKeyHolder(0x1a7ee00, 0xc4201fc5a0, 0xc4201fc5a0, 0x127b962)
        /home/travis/build/kubernetes/dashboard/.tmp/backend/src/github.com/kubernetes/dashboard/src/app/backend/auth/jwe/keyholder.go:170 +0x83
    main.initAuthManager(0x1a7e300, 0xc420053aa0, 0xc42055dc68, 0x1)
        /home/travis/build/kubernetes/dashboard/.tmp/backend/src/github.com/kubernetes/dashboard/src/app/backend/dashboard.go:183 +0x12f
    main.main()
        /home/travis/build/kubernetes/dashboard/.tmp/backend/src/github.com/kubernetes/dashboard/src/app/backend/dashboard.go:101 +0x28c

[1]: https://github.com/rancher/rancher/issues/12600
[2]: https://github.com/bitnami/bitnami-docker-redis/issues/100
[3]: https://serverfault.com/questions/453185/vagrant-virtualbox-dns-10-0-2-3-not-working
