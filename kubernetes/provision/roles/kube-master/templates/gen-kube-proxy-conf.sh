# generate .kubeconfig for kube-proxy

kubectl config set-cluster {{ cluster_name }} \
  --certificate-authority={{ sys_share_ca_dir }}/ownca.crt \
  --embed-certs=true \
  --server=https://{{ kubernetes_public_address }}:6443 \
  --kubeconfig={{ kube_data_dir }}/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate={{ kube_data_dir }}/kube-proxy.pem \
  --client-key={{ kube_data_dir }}/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig={{ kube_data_dir }}/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster={{ cluster_name }} \
  --user=system:kube-proxy \
  --kubeconfig={{ kube_data_dir }}/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig={{ kube_data_dir }}/kube-proxy.kubeconfig