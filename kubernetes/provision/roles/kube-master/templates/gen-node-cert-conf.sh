# generate certificate and kubeconfig in one go

if [ ! -f {{ temp_data_dir }}/{{ item }}.kubeconfig ]; then
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

  # EXTERNAL_IP=192.168.90.$(expr $n + 25)
  # INTERNAL_IP=192.168.90.$(expr $n + 25)
  # -hostname={{ item }},EXTERNAL_IP,INTERNAL_IP \

  cfssl gencert \
    -ca={{ kube_data_dir }}/ownca.pem \
    -ca-key={{ kube_data_dir }}/ownca-key.pem \
    -config={{ temp_data_dir }}/ownca-config.json \
    -hostname={{ item }} \
    -profile=kubernetes \
    {{ temp_data_dir }}/{{ item }}-csr.json | cfssljson -bare {{ temp_data_dir }}/{{ item }}

  kubectl config set-cluster {{ cluster_name }} \
    --certificate-authority={{ kube_data_dir }}/ownca.pem \
    --embed-certs=true \
    --server=https://{{ kubernetes_public_address }}:6443 \
    --kubeconfig={{ temp_data_dir }}/{{ item }}.kubeconfig

  kubectl config set-credentials system:node:{{ item }} \
    --client-certificate={{ temp_data_dir }}/{{ item }}.pem \
    --client-key={{ temp_data_dir }}/{{ item }}-key.pem \
    --embed-certs=true \
    --kubeconfig={{ temp_data_dir }}/{{ item }}.kubeconfig

  kubectl config set-context default \
    --cluster={{ cluster_name }} \
    --user=system:node:{{ item }} \
    --kubeconfig={{ temp_data_dir }}/{{ item }}.kubeconfig

  kubectl config use-context default --kubeconfig={{ temp_data_dir }}/{{ item }}.kubeconfig

fi