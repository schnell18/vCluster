tk=$(kubectl get sa/admin -n kube-system -o=jsonpath={.secrets[0].name})
if [ -z $tk ]; then
  exit 1
else
  kubectl describe secret/$tk -n kube-system | grep token: | awk '{print $2}'
fi
