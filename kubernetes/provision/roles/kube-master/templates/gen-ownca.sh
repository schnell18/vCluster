# generates own ca
cat << EOF | cfssl gencert -initca - | cfssljson -bare {{ kube_data_dir }}/ownca
{
  "CN": "{{ ownca_cn}}",
  "key": {
    "algo": "rsa",
    "size": {{ ownca_key_size }}
  },
  "names": [
    {
      "C": "{{ ownca_c }}",
      "L": "{{ ownca_l }}",
      "O": "{{ ownca_o }}",
      "OU": "{{ ownca_ou }}",
      "ST": "{{ ownca_st }}"
    }
  ]
}
EOF

cat << EOF > {{ temp_data_dir }}/ownca-config.json
{
  "signing": {
    "default": {
      "expiry": "{{ ownca_expiry }}"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "{{ ownca_expiry }}"
      }
    }
  }
}
EOF