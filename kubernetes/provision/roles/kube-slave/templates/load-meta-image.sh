if [[ ! -f /work/.preload/meta-images.tar ]]; then
  echo "Pre-load meta images such as pause ..."
  images=(                             \
    pause-amd64:3.1                    \
    pause3.1                           \
    kubernetes-dashboard-amd64:v1.8.3  \
    k8s-dns-sidecar-amd64:1.14.8       \
    k8s-dns-kube-dns-amd64:1.14.8      \
    k8s-dns-dnsmasq-nanny-amd64:1.14.8 \
  )
  for imageName in ${images[@]} ; do
    crictl pull k8s.gcr.io/$imageName
  done
else
  echo "Pre-load(from local cache) meta images such as pause ..."
  ctr cri load /work/.preload/meta-images.tar
fi
