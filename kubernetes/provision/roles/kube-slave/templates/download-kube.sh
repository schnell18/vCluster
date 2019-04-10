[ ! -d /work/.preload] && mkdir -p /work/.preload
if [ ! -f /work/.preload/kube-proxy ]; then
  baseurl1="https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64"
  baseurl2="https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.11.0"
  baseurl3="https://github.com/opencontainers/runc/releases/download/v1.0.0-rc5"
  baseurl4="https://github.com/containernetworking/plugins/releases/download/v0.6.0/"
  baseurl5="https://github.com/containerd/containerd/releases/download/v1.1.1"

  echo "Downloading containerd, cni-plugins kubelet and kube-proxy etc..."
  pushd /work/.preload
  tsocks wget -q                                            \
    "$baseurl5/containerd-1.1.1.linux-amd64.tar.gz"         \
    "$baseurl4/cni-plugins-amd64-v0.6.0.tgz"                \
    "$baseurl3/runc.amd64"                                  \
    "$baseurl2/crictl-v1.11.0-linux-amd64.tar.gz"           \
    "$baseurl1/kubelet"                                     \
    "$baseurl1/kube-proxy"
  popd
fi
