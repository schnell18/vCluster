if [ ! -f /usr/local/bin/kube-proxy ]; then
  mkdir -p              \
    /etc/cni/net.d      \
    /opt/cni/bin        \
    /var/lib/kubelet    \
    /var/lib/kube-proxy \
    /var/lib/kubernetes \
    /var/run/kubernetes

  pushd /work/.preload
  cp kubectl kube-proxy kubelet /usr/local/bin/
  cp runc.amd64 /usr/local/bin/runc
  tar -xzvf crictl-v1.11.0-linux-amd64.tar.gz -C /usr/local/bin/ > /dev/null
  tar -xzvf cni-plugins-amd64-v0.6.0.tgz -C /opt/cni/bin/ > /dev/null
  tar -xzvf containerd-1.1.1.linux-amd64.tar.gz -C /tmp > /dev/null
  mv /tmp/bin/* /usr/local/bin
  chmod +x /usr/local/bin/{kubectl,kube-proxy,kubelet,runc}
  popd
fi
