[ ! -d /work/.preload ] && mkdir -p /work/.preload
if [ ! -f /work/.preload/kube-apiserver ]; then
    baseurl="https://storage.googleapis.com/kubernetes-release/release/v1.11.0/bin/linux/amd64"
    echo "Downloading kube-apiserver kube-controller-manager etc..."
    pushd /work/.preload
    tsocks wget -q                       \
      "$baseurl/kube-apiserver"          \
      "$baseurl/kube-controller-manager" \
      "$baseurl/kube-scheduler"          \
      "$baseurl/kubectl"
    popd
fi
