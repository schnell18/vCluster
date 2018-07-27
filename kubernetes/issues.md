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

## mongodb statefulset fail to start


    23:33 $ kubectl describe statefulsets mongo
    Name:		mongo
    Namespace:	default
    Labels:		<none>
    Events:
    FirstSeen	LastSeen	Count	From			SubObjectPath	Type		Reason		Message
    ---------	--------	-----	----			-------------	--------	------		-------
    1m		1m		12	statefulset-controller			Warning		FailedCreate	create Pod mongo-0 in StatefulSet mongo failed error: Failed to create PVC -mongo-0: PersistentVolumeClaim "-mongo-0" is invalid: metadata.name: Invalid value: "-mongo-0": a DNS-1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')
    1m		1m		13	statefulset-controller			Warning		FailedCreate	create Claim -mongo-0 for Pod mongo-0 in StatefulSet mongo failed error: PersistentVolumeClaim "-mongo-0" is invalid: metadata.name: Invalid value: "-mongo-0": a DNS-1123 subdomain must consist of lower case alphanumeric characters, '-' or '.', and must start and end with an alphanumeric character (e.g. 'example.com', regex used for validation is '[a-z0-9]([-a-z0-9]*[a-z0-9])?(\.[a-z0-9]([-a-z0-9]*[a-z0-9])?)*')

## delete statefulset get segfault

    panic: runtime error: invalid memory address or nil pointer dereference
    [signal SIGSEGV: segmentation violation code=0x1 addr=0x20 pc=0x2545fe9]

    goroutine 1 [running]:
    k8s.io/kubernetes/pkg/kubectl.ReaperFor(0xc420340e60, 0x4, 0xc420340ec0, 0xb, 0x0, 0x0, 0xc420645d70, 0xc420939390, 0xc4203a8f38, 0xc4203a8d08)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/stop.go:92 +0xe39
    k8s.io/kubernetes/pkg/kubectl/cmd/util.(*ring1Factory).Reaper(0xc4201b8580, 0xc4202fe3f0, 0xc420939380, 0x2, 0x2, 0x2a56811)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/cmd/util/factory_object_mapping.go:290 +0x160
    k8s.io/kubernetes/pkg/kubectl/cmd/util.(*factory).Reaper(0xc4206f2150, 0xc4202fe3f0, 0x9, 0xc4209393e0, 0x14f3b20, 0xc4204744d8)
        <autogenerated>:92 +0x54
    k8s.io/kubernetes/pkg/kubectl/cmd.ReapResult.func1(0xc4202c4d80, 0x0, 0x0, 0x9, 0x1df6e01)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/cmd/delete.go:252 +0xdb
    k8s.io/kubernetes/pkg/kubectl/resource.ContinueOnErrorVisitor.Visit.func1(0xc4202c4d80, 0x0, 0x0, 0x0, 0x0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:348 +0x153
    k8s.io/kubernetes/pkg/kubectl/resource.DecoratedVisitor.Visit.func1(0xc4202c4d80, 0x0, 0x0, 0x0, 0x0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:324 +0xdf
    k8s.io/kubernetes/pkg/kubectl/resource.FlattenListVisitor.Visit.func1(0xc4202c4d80, 0x0, 0x0, 0xc4209396c0, 0x1042ef3)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:389 +0x572
    k8s.io/kubernetes/pkg/kubectl/resource.EagerVisitorList.Visit.func1(0xc4202c4d80, 0x0, 0x0, 0x380, 0xc4202989d0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:207 +0x153
    k8s.io/kubernetes/pkg/kubectl/resource.(*StreamVisitor).Visit(0xc4203e4140, 0xc420845360, 0x36dcc00, 0xc4208453c0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:552 +0x350
    k8s.io/kubernetes/pkg/kubectl/resource.(*FileVisitor).Visit(0xc420845200, 0xc420845360, 0x0, 0x0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:501 +0x1a6
    k8s.io/kubernetes/pkg/kubectl/resource.EagerVisitorList.Visit(0xc42031eb10, 0x1, 0x1, 0xc4206f2bd0, 0x1, 0xc4206f2bd0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:211 +0x100
    k8s.io/kubernetes/pkg/kubectl/resource.(*EagerVisitorList).Visit(0xc4208452a0, 0xc4206f2bd0, 0x3cb9960, 0x0)
        <autogenerated>:122 +0x69
    k8s.io/kubernetes/pkg/kubectl/resource.FlattenListVisitor.Visit(0x36d8e80, 0xc4208452a0, 0xc4203e4100, 0xc4203e4180, 0xc420845301, 0xc4203e4180)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:417 +0xa3
    k8s.io/kubernetes/pkg/kubectl/resource.(*FlattenListVisitor).Visit(0xc4208452c0, 0xc4203e4180, 0x18, 0x18)
        <autogenerated>:138 +0x69
    k8s.io/kubernetes/pkg/kubectl/resource.DecoratedVisitor.Visit(0x36d8f00, 0xc4208452c0, 0xc42031eb20, 0x2, 0x2, 0xc420845320, 0x1, 0xc420845320)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:325 +0xd8
    k8s.io/kubernetes/pkg/kubectl/resource.(*DecoratedVisitor).Visit(0xc4206f2ba0, 0xc420845320, 0xc4206f2ba0, 0xc4207a1a88)
        <autogenerated>:158 +0x73
    k8s.io/kubernetes/pkg/kubectl/resource.ContinueOnErrorVisitor.Visit(0x36d8e00, 0xc4206f2ba0, 0xc4202947e0, 0x3cb9960, 0x0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/visitor.go:352 +0xf1
    k8s.io/kubernetes/pkg/kubectl/resource.(*ContinueOnErrorVisitor).Visit(0xc42031eb30, 0xc4202947e0, 0x100f2e8, 0x70)
        <autogenerated>:153 +0x60
    k8s.io/kubernetes/pkg/kubectl/resource.(*Result).Visit(0xc420294770, 0xc4202947e0, 0x37a9b48, 0x36d8e00)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/resource/result.go:96 +0x62
    k8s.io/kubernetes/pkg/kubectl/cmd.ReapResult(0xc420294770, 0x36fbd60, 0xc4206f2150, 0x36d7e00, 0xc42000c018, 0x36d0001, 0x0, 0xffffffffffffffff, 0x36f0000, 0x36f3540, ...)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/cmd/delete.go:277 +0x175
    k8s.io/kubernetes/pkg/kubectl/cmd.(*DeleteOptions).RunDelete(0xc420144e70, 0x36fbd60, 0xc4206f2150)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/cmd/delete.go:237 +0xf5
    k8s.io/kubernetes/pkg/kubectl/cmd.NewCmdDelete.func1(0xc420227d40, 0xc420150520, 0x0, 0x2)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/pkg/kubectl/cmd/delete.go:143 +0x17c
    k8s.io/kubernetes/vendor/github.com/spf13/cobra.(*Command).execute(0xc420227d40, 0xc420150060, 0x2, 0x2, 0xc420227d40, 0xc420150060)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/vendor/github.com/spf13/cobra/command.go:603 +0x22b
    k8s.io/kubernetes/vendor/github.com/spf13/cobra.(*Command).ExecuteC(0xc4202f7680, 0x27, 0x2a7f972, 0x27)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/vendor/github.com/spf13/cobra/command.go:689 +0x339
    k8s.io/kubernetes/vendor/github.com/spf13/cobra.(*Command).Execute(0xc4202f7680, 0xc4206f2150, 0x36d7dc0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/vendor/github.com/spf13/cobra/command.go:648 +0x2b
    k8s.io/kubernetes/cmd/kubectl/app.Run(0x0, 0x0)
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/cmd/kubectl/app/kubectl.go:39 +0xd5
    main.main()
        /private/tmp/kubernetes-cli-20170519-56130-14l9tbm/src/k8s.io/kubernetes/_output/local/go/src/k8s.io/kubernetes/cmd/kubectl/kubectl.go:26 +0x22

[1]: https://github.com/rancher/rancher/issues/12600
[2]: https://github.com/bitnami/bitnami-docker-redis/issues/100
[3]: https://serverfault.com/questions/453185/vagrant-virtualbox-dns-10-0-2-3-not-working
