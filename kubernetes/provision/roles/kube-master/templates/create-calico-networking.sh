found=$(kubectl get ds -n kube-system | grep calico)
if [ -z $found ]; then

  cat <<EOF | kubectl create -f -
{{ lookup('template', 'calico.yaml') }}
EOF
  echo "Created calico networking"
fi