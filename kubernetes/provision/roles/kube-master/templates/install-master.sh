if [ ! -f /usr/local/bin/kube-apiserver ]; then
  pushd /work/.preload
  cp kube-apiserver kube-controller-manager kube-scheduler kubectl /usr/local/bin/
  chmod +x /usr/local/bin/{kube-apiserver,kube-controller-manager,kube-scheduler,kubectl}
  popd
fi
