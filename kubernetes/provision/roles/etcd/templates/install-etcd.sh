if [ ! -f /usr/local/bin/etcd ]; then
  pushd /work/.preload
  cp etcd /usr/local/bin/
  chmod +x /usr/local/bin/etcd
  popd
fi

if [ ! -f /usr/local/bin/etcdctl ]; then
  pushd /work/.preload
  cp etcdctl /usr/local/bin/
  chmod +x /usr/local/bin/etcdctl
  popd
fi
