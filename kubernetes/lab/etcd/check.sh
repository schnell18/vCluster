etcdctl \
  --ca-file /etc/etcd/ca.pem \
  --cert-file /etc/etcd/kubernetes.pem \
  --key-file /etc/etcd/kubernetes-key.pem \
  member list