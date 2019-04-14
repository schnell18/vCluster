[ ! -d /work/.preload ] && mkdir -p /work/.preload
if [ ! -f /work/.preload/etcd ]; then
    archive="etcd-v{{ etcd_version }}-linux-amd64.tar.gz"
    baseurl="https://github.com/etcd-io/etcd/releases/download/v{{ etcd_version }}/$archive"
    echo "Downloading etcd..."
    pushd /tmp
    tsocks wget -q "$baseurl"
    tar -xzvf $archive "etcd-v{{ etcd_version }}-linux-amd64/etcd" "etcd-v{{ etcd_version }}-linux-amd64/etcdctl"
    cp "etcd-v{{ etcd_version }}-linux-amd64/etcd" /work/.preload
    cp "etcd-v{{ etcd_version }}-linux-amd64/etcdctl" /work/.preload
    popd
fi
