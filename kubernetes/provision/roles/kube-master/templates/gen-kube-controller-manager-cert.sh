# generate certificate for kube-controller-manager

cat > {{ temp_data_dir }}/kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "{{ ownca_c }}",
      "L": "{{ ownca_l }}",
      "O": "system:kube-controller-manager",
      "OU": "{{ kube_controller_manager_ou }}",
      "ST": "{{ ownca_st }}"
    }
  ]
}
EOF

cfssl gencert \
  -ca={{ sys_share_ca_dir }}/ownca.crt \
  -ca-key={{ kube_data_dir }}/ownca-key.pem \
  -config={{ kube_data_dir }}/ownca-config.json \
  -profile=kubernetes \
  {{ temp_data_dir }}/kube-controller-manager-csr.json | cfssljson -bare {{ kube_data_dir }}/kube-controller-manager
