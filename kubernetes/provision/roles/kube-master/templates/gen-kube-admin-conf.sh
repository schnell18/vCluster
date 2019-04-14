# generate .kubeconfig for cluster admin

kubectl config set-cluster {{ cluster_name }} \
  --certificate-authority={{ kube_data_dir }}/ownca.pem \
  --embed-certs=true \
  --server=https://{{ kubernetes_public_address }}:6443 \
  --kubeconfig={{ kube_data_dir }}/admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate={{ kube_data_dir }}/admin.pem \
  --client-key={{ kube_data_dir }}/admin-key.pem \
  --embed-certs=true \
  --kubeconfig={{ kube_data_dir }}/admin.kubeconfig

kubectl config set-context default \
  --cluster=my-kube \
  --user=admin \
  --kubeconfig={{ kube_data_dir }}/admin.kubeconfig

kubectl config use-context default --kubeconfig={{ kube_data_dir }}/admin.kubeconfig
if [ ! -d ~root/.kube ]; then
   mkdir -p ~root/.kube
fi
cp {{ kube_data_dir }}/admin.kubeconfig ~root/.kube/config

if [ ! -d ~devel/.kube ]; then
   mkdir -p ~devel/.kube
fi
cp {{ kube_data_dir }}/admin.kubeconfig ~devel/.kube/config
chown devel.devel ~devel/.kube/config