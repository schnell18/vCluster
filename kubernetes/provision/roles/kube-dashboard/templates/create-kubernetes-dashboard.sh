found=$(kubectl get deployment/kubernetes-dashboard -n kube-system | grep kubernetes-dashboard)
if [ -z $found ]; then
  kubectl create -f /work/provision/admin/kubernetes-dashboard.yaml
  echo "Created kubernetes dashboard"
fi