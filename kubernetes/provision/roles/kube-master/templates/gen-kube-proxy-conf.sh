# generate .kubeconfig for kube-proxy

kubectl config set-cluster {{ cluster_name }} \
  --certificate-authority={{ kube_data_dir }}/ownca.pem \
  --embed-certs=true \
  --server=https://{{ kubernetes_public_address }}:6443 \
  --kubeconfig={{ temp_data_dir }}/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate={{ temp_data_dir }}/kube-proxy.pem \
  --client-key={{ temp_data_dir }}/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig={{ temp_data_dir }}/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster={{ cluster_name }} \
  --user=system:kube-proxy \
  --kubeconfig={{ temp_data_dir }}/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig={{ temp_data_dir }}/kube-proxy.kubeconfig