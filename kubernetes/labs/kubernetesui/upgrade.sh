kubectl set image \
  deployment.v1.apps/kubernetes-dashboard \
  kubernetes-dashboard=kubernetesui/dashboard:v2.0.0-rc6 \
  --record
