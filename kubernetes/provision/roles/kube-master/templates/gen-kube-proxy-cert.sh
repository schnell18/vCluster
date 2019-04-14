# generate certifcate for kube-proxy
cat > {{ temp_data_dir }}/kube-proxy-csr.json <<EOF
{
  "CN": "{{ kube_proxy_cn }}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "{{ ownca_c }}",
      "L": "{{ ownca_l }}",
      "O": "{{ kube_proxy_o }}",
      "OU": "{{ kube_proxy_ou }}",
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
  {{ temp_data_dir }}/kube-proxy-csr.json | cfssljson -bare {{ kube_data_dir }}/kube-proxy
