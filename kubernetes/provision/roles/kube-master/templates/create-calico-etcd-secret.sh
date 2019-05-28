found=$(kubectl get secret/calico-etcd-secrets -n kube-system | grep calico-etcd-secrets)
if [ -z $found ]; then

  kubectl create secret generic calico-etcd-secrets             \
    --from-file=etcd-cert={{ kube_conf_dir }}/pki/apiserver-etcd-client.crt \
    --from-file=etcd-key={{ kube_conf_dir }}/pki/apiserver-etcd-client.key \
    --from-file=etcd-ca={{ kube_conf_dir }}/pki/etcd/ca.crt           \
    --namespace kube-system
  echo "Created etcd client cert secrets"

fi