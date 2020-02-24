found=$(kubectl get ds -n default | grep local-volume-provisioner)
if [ -z $found ]; then

  cat <<EOF | kubectl create -f -
{{ lookup('template', 'sig-storage-local-static-provisioner.yaml') }}
EOF
  echo "Created local persistent volume provisioner"
fi