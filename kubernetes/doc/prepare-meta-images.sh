# images=(                                        \
#   k8s.gcr.io/pause:3.1                          \
#   k8s.gcr.io/pause-amd64:3.1                    \
#   k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3  \
#   k8s.gcr.io/hyperkube:1.11.0                   \
#   k8s.gcr.io/etcd:3.2.18                        \
#   k8s.gcr.io/k8s-dns-sidecar-amd64:1.14.8       \
#   k8s.gcr.io/k8s-dns-kube-dns-amd64:1.14.8      \
#   k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64:1.14.8 \
#   gcr.io/kubernetes-helm/tiller:v2.10.0         \
# )

images=(                                        \
  k8s.gcr.io/hyperkube:1.11.0                   \
  k8s.gcr.io/etcd:3.2.18                        \
)
for imageName in ${images[@]} ; do
  docker pull $imageName
done

# for imageName in ${images[@]} ; do
#   docker pull anjia0532/$imageName
#   docker tag anjia0532/$imageName k8s.gcr.io/$imageName
#   docker rmi anjia0532/$imageName
# done

docker pull quay.io/calico/cni:v3.1.3
docker pull quay.io/calico/kube-controllers:v3.1.3
docker pull quay.io/calico/node:v3.1.3
docker pull quay.io/calico/ctl:v3.1.3

docker save                                       \
    k8s.gcr.io/k8s-dns-dnsmasq-nanny-amd64:1.14.8 \
    k8s.gcr.io/k8s-dns-kube-dns-amd64:1.14.8      \
    k8s.gcr.io/k8s-dns-sidecar-amd64:1.14.8       \
    k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3  \
    k8s.gcr.io/kubernetes-zookeeper:1.0-3.4.10    \
    k8s.gcr.io/pause-amd64:3.1                    \
    k8s.gcr.io/pause:3.1                          \
    quay.io/calico/cni:v3.1.3                     \
    quay.io/calico/kube-controllers:v3.1.3        \
    quay.io/calico/node:v3.1.3                    \
    quay.io/calico/ctl:v3.1.3                     \
    k8s.gcr.io/heapster-influxdb-amd64:v1.3.3     \
    k8s.gcr.io/heapster-amd64:v1.5.3              \
    gcr.io/kubernetes-helm/tiller:v2.10.0         \
    harbor.dev.pajkdc.com/pajk_dev:1.6.0-alpine   \
    > meta-images.tar

docker save                                       \
    gcr.io/kubernetes-helm/tiller:v2.10.0 > tiller.tar
