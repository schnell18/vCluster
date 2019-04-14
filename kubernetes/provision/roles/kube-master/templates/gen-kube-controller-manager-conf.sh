# generate .kubeconfig for kube-scheduler

kubectl config set-cluster {{ cluster_name }} \
  --certificate-authority={{ kube_data_dir }}/ownca.pem \
  --embed-certs=true \
  --server=https://{{ kubernetes_public_address }}:6443 \
  --kubeconfig={{ kube_data_dir }}/kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate={{ kube_data_dir }}/kube-controller-manager.pem \
  --client-key={{ kube_data_dir }}/kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig={{ kube_data_dir }}/kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster={{ cluster_name }} \
  --user=system:kube-controller-manager \
  --kubeconfig={{ kube_data_dir }}/kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig={{ kube_data_dir }}/kube-controller-manager.kubeconfig