# generate certificates for apiserver
cat > {{ temp_data_dir }}/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "{{ ownca_c }}",
      "L": "{{ ownca_l }}",
      "O": "kubernetes",
      "OU": "{{ apiserver_ou }}",
      "ST": "{{ ownca_st }}"
    }
  ]
}
EOF

cfssl gencert \
  -ca={{ sys_share_ca_dir }}/ownca.crt \
  -ca-key={{ kube_data_dir }}/ownca-key.pem \
  -config={{ kube_data_dir }}/ownca-config.json \
  -hostname=127.0.0.1,10.200.0.10,10.32.0.1,10.200.0.11,{{ kubernetes_public_address }},localhost,kubernetes.default \
  -profile=kubernetes \
  {{ temp_data_dir }}/kubernetes-csr.json | cfssljson -bare {{ kube_data_dir }}/kubernetes
