# containerd image management

The kubernetes 1.10 supports a new container runtime called containerd
which is more performant according to [Kubernetes Containerd Integration
Goes GA][1].  However, with the new runtime, image management is quite
different from docker. And you have to use crictl rather than docker to
manage images. Common options are as follows:

- pull
- images

The images pulled by containerd seem to located under
/var/lib/containerd/io.containerd.content.v1.content.

## gcr images workaround

Due to the GFW, images from google gcr registry, for instance,
[pause][3] is vital for kubernetes to work, can not be pulled. Even
worse the `crictl` tool does not support tag image. To workaround this
issue we may pull the image clones built by third-party, re-tag them and
save to a tar file. Then we load these images with the `crictl` tool.
The first step to pull, re-tag and save the images from k8s.gcr.io
repository. The complete commands are as follows:

    #!/bin/bash
    VER=v1.10.2
    images=(                             \
      kube-proxy-amd64:$VER              \
      kube-scheduler-amd64:$VER          \
      kube-controller-manager-amd64:$VER \
      kube-apiserver-amd64:$VER          \
      etcd-amd64:3.1.12                  \
      pause-amd64:3.1                    \
      pause:3.1                          \
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

    docker save \
      k8s.gcr.io/pause:3.1 \
      k8s.gcr.io/pause-amd64:3.1 \
      k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3 \
      k8s.gcr.io/k8s-dns-sidecar-amd64:1.14.8 \
      k8s.gcr.io/k8s-dns-kube-dns-amd64:1.14.8 > imgs.tar

Then we load the images as follows:

    ctr cri load imgs.tar

## fast mirror

If you wish to use a fast mirror in China, you should prepend your preferred
registry in the endpoint list as follows:

    [plugins.cri.registry.mirrors]
      [plugins.cri.registry.mirrors."docker.io"]
        endpoint = ["https://registry.docker-cn.com", "https://registry-1.docker.io"]

These configuration goes to /etc/containerd/config.toml by default.

## pull image size validation failure workaroudn

The image management offerred by containerd does not seem mature. You
may come across error like:

    [root@kbn1 ~]# /usr/local/bin/crictl pull nginx:alpine
    FATA[0022] pulling image failed: rpc error: code = Unknown desc = failed to pull image "docker.io/library/nginx:alpine": failed commit on ref "layer-sha256:ff3a5c916c92643ff77519ffa742d3ec61b7f591b6b7504599d95a4a41134e28": "layer-sha256:ff3a5c916c92643ff77519ffa742d3ec61b7f591b6b7504599d95a4a41134e28" failed size validation: 2775088 != 2065537

This is a known issue which was reported by [2306][2]. The workaround is
to remove all sub directories under
/var/lib/containerd/io.containerd.content.v1.content/ingest. Make sure
you retain the empty `ingest` directory though.

# check pod status

You may use kubectl describe pods <pod-name> to get in-depth
information. For example:

    [devel@kbm1 ~]$ kubectl describe pods nginx3
    Name:         nginx3
    Namespace:    default
    Node:         kbn1.kube.vn/192.168.90.25
    Start Time:   Sun, 27 May 2018 09:08:35 +0800
    Labels:       run=nginx3
    Annotations:  <none>
    Status:       Running
    IP:           10.200.0.26
    Containers:
      nginx3:
        Container ID:   containerd://880a4bd35c55f1b4e9f53e6ab31b92a4f830e414e1bc2205c349d4908d75124c
        Image:          nginx:alpine
        Image ID:       docker.io/library/nginx@sha256:3a44395131c5a9704417d19ab4c8d6cb104013659f5babb2f1c632e789588196
        Port:           <none>
        Host Port:      <none>
        State:          Running
          Started:      Sun, 27 May 2018 09:08:37 +0800
        Ready:          True
        Restart Count:  0
        Environment:    <none>
        Mounts:
          /var/run/secrets/kubernetes.io/serviceaccount from default-token-wkjv7 (ro)
    Conditions:
      Type           Status
      Initialized    True
      Ready          True
      PodScheduled   True
    Volumes:
      secretvol:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  mysecret
        Optional:    false
      default-token-wkjv7:
        Type:        Secret (a volume populated by a Secret)
        SecretName:  default-token-wkjv7
        Optional:    false
    QoS Class:       BestEffort
    Node-Selectors:  <none>
    Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                     node.kubernetes.io/unreachable:NoExecute for 300s
    Events:
      Type    Reason                 Age   From                   Message
      ----    ------                 ----  ----                   -------
      Normal  Scheduled              25m   default-scheduler      Successfully assigned nginx3 to kbn1.kube.vn
      Normal  SuccessfulMountVolume  25m   kubelet, kbn1.kube.vn  MountVolume.SetUp succeeded for volume "default-token-wkjv7"
      Normal  SuccessfulMountVolume  25m   kubelet, kbn1.kube.vn  MountVolume.SetUp succeeded for volume "secretvol"
      Normal  Pulled                 25m   kubelet, kbn1.kube.vn  Container image "nginx:alpine" already present on machine
      Normal  Created                25m   kubelet, kbn1.kube.vn  Created container
      Normal  Started                25m   kubelet, kbn1.kube.vn  Started container

[1]: https://kubernetes.io/blog/2018/05/24/kubernetes-containerd-integration-goes-ga/
[2]: https://github.com/containerd/containerd/issues/2306
[3]: https://www.ianlewis.org/en/almighty-pause-container
