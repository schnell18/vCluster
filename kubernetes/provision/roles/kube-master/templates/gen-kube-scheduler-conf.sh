# generate .kubeconfig for kube-scheduler

kubectl config set-cluster {{ cluster_name }} \
  --certificate-authority={{ sys_share_ca_dir }}/ownca.crt \
  --embed-certs=true \
  --server=https://{{ kubernetes_public_address }}:6443 \
  --kubeconfig={{ kube_data_dir }}/kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
  --client-certificate={{ kube_data_dir }}/kube-scheduler.pem \
  --client-key={{ kube_data_dir }}/kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig={{ kube_data_dir }}/kube-scheduler.kubeconfig

kubectl config set-context default \
  --cluster={{ cluster_name }} \
  --user=system:kube-scheduler \
  --kubeconfig={{ kube_data_dir }}/kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig={{ kube_data_dir }}/kube-scheduler.kubeconfig