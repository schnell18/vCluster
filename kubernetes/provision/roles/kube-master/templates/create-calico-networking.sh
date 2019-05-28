found=$(kubectl get ds -n kube-system | grep calico)
if [ -z $found ]; then
  kubectl create -f /work/provision/network/calico.yaml
  echo "Created calico networking"
fi