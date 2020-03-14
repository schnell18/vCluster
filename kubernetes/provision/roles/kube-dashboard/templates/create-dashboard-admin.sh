found=$(kubectl get sa/admin -n kube-system | grep admin)
if [ -z $found ]; then

  cat <<EOF | kubectl apply -f -
{{ lookup('file', 'dashboard-admin.yaml') }}
EOF
  echo "Created dashboard admin"
fi