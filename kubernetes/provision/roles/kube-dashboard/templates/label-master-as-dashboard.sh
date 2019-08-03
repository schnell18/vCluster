found=$(kubectl get nodes/master --show-labels | grep dashboard=true)
if [ -z $found ]; then
  kubectl label nodes master dashboard=true
  echo "Label dashboard on master created"
fi