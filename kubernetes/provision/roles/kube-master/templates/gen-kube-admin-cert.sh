# generate certificate for kubernetes admin
cat > {{ temp_data_dir }}/admin-csr.json <<EOF
{
  "CN": "{{ kube_admin_cn }}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "{{ ownca_c }}",
      "L": "{{ ownca_l }}",
      "O": "{{ kube_admin_o }}",
      "OU": "{{ kube_admin_ou }}",
      "ST": "{{ ownca_st }}"
    }
  ]
}
EOF

cfssl gencert \
  -ca={{ kube_data_dir }}/ownca.pem \
  -ca-key={{ kube_data_dir }}/ownca-key.pem \
  -config={{ temp_data_dir }}/ownca-config.json \
  -profile=kubernetes \
  {{ temp_data_dir }}/admin-csr.json | cfssljson -bare {{ kube_data_dir }}/admin
