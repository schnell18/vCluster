# generate certificates for etcd kubernetes client
cat<<EOF > {{ temp_data_dir }}/etcd-kube-client-csr.json
{
  "CN": "etcd-kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "{{ ownca_c }}",
      "L": "{{ ownca_l }}",
      "O": "etcd-kubernetes",
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
  -profile=kubernetes \
  -hostname=127.0.0.1,localhost,kubernetes.default \
  {{ temp_data_dir }}/etcd-kube-client-csr.json | cfssljson -bare {{ etcd_data_dir }}/default/etcd-kube-client

chown etcd.etcd {{ etcd_data_dir }}/default/etcd-kube-client.pem
chown etcd.etcd {{ etcd_data_dir }}/default/etcd-kube-client-key.pem