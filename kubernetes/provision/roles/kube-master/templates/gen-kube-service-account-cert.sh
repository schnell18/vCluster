# generate certificates for service-account
cat > {{ temp_data_dir }}/service-account-csr.json <<EOF
{
  "CN": "{{ service_account_cn }}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "{{ ownca_c }}",
      "L": "{{ ownca_l }}",
      "O": "{{ service_account_o }}",
      "OU": "{{ service_account_ou }}",
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
  {{ temp_data_dir }}/service-account-csr.json | cfssljson -bare {{ kube_data_dir }}/service-account
