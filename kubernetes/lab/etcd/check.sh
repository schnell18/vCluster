etcdctl \
  --ca-file /etc/etcd/ca.pem \
  --cert-file /etc/etcd/kubernetes.pem \
  --key-file /etc/etcd/kubernetes-key.pem \
  member list

# pass ca, cert and key via environment varible as follows:
cat <<EOF >> ~/.bash_profile
export ETCDCTL_ENDPOINTS=https://localhost:2379
export ETCDCTL_API=3
export ETCDCTL_CACERT=/var/lib/etcd/default/ownca.pem
export ETCDCTL_CERT=/var/lib/etcd/default/kubernetes.pem
export ETCDCTL_KEY=/var/lib/etcd/default/kubernetes-key.pem
EOF

etcdctl member list
