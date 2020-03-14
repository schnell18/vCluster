KUBEADM_CFG=/tmp/001-kubeadm.yaml
cat <<EOF > $KUBEADM_CFG
{{ lookup('template', 'kubeadm.yaml') }}
EOF
kubeadm init \
    --node-name {{ hostvars[inventory_hostname]['inventory_hostname_short'] }} \
    --config $KUBEADM_CFG