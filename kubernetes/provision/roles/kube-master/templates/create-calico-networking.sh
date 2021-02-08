found=$(kubectl get ds -n kube-system | grep calico)
if [[ -z $found && -f /tmp/calico.yaml ]]; then
  kubectl apply -f /tmp/calico.yaml
  echo "Created calico networking"
fi
