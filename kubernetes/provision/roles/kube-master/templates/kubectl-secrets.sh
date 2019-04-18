echo "Loading root-ca certificates into secret..."
kubectl create secret generic root-ca-certs                 \
  --from-file=tls-ca-bundle.pem={{ sys_share_ca_dir }}/ownca.crt  \
  --namespace kube-system

echo "Loading etcd key, certificates and ca into secret..."
kubectl create secret generic calico-etcd-secrets             \
  --from-file=etcd-cert={{ kube_data_dir }}/kubernetes.pem    \
  --from-file=etcd-key={{ kube_data_dir }}/kubernetes-key.pem \
  --from-file=etcd-ca={{ sys_share_ca_dir }}/ownca.crt           \
  --namespace kube-system
