# generate certificate and kubeconfig in one go

if [ ! -f {{ kube_data_dir }}/{{ item }}.kubeconfig ]; then
echo "Generating .kubeconfig for {{ item }}..."
cat > {{ temp_data_dir }}/{{ item }}-csr.json << EOF
{
  "CN": "system:node:{{ item }}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "{{ ownca_c }}",
      "L": "{{ ownca_l }}",
      "O": "system:nodes",
      "OU": "jjhome",
      "ST": "{{ ownca_st }}"
    }
  ]
}
EOF

  cfssl gencert \
    -ca={{ sys_share_ca_dir }}/ownca.crt \
    -ca-key={{ kube_data_dir }}/ownca-key.pem \
    -config={{ kube_data_dir }}/ownca-config.json \
    -hostname={{ item }} \
    -profile=kubernetes \
    {{ temp_data_dir }}/{{ item }}-csr.json | cfssljson -bare {{ kube_data_dir }}/{{ item }}

  kubectl config set-cluster {{ cluster_name }} \
    --certificate-authority={{ sys_share_ca_dir }}/ownca.crt \
    --embed-certs=true \
    --server=https://{{ kubernetes_public_address }}:6443 \
    --kubeconfig={{ kube_data_dir }}/{{ item }}.kubeconfig

  kubectl config set-credentials system:node:{{ item }} \
    --client-certificate={{ kube_data_dir }}/{{ item }}.pem \
    --client-key={{ kube_data_dir }}/{{ item }}-key.pem \
    --embed-certs=true \
    --kubeconfig={{ kube_data_dir }}/{{ item }}.kubeconfig

  kubectl config set-context default \
    --cluster={{ cluster_name }} \
    --user=system:node:{{ item }} \
    --kubeconfig={{ kube_data_dir }}/{{ item }}.kubeconfig

  kubectl config use-context default --kubeconfig={{ kube_data_dir }}/{{ item }}.kubeconfig

fi