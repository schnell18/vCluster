found=$(kubectl get sa/admin -n kube-system | grep admin)
if [ -z $found ]; then
  kubectl create -f /work/provision/admin/dashboard-admin.yaml
  echo "Created dashboard admin"
fi