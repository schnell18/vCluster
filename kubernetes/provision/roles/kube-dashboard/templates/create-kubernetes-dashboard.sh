kubectl get deployment/kubernetes-dashboard -n kubernetes-dashboard
if [ $? -eq 0 ]; then
    exit 0
fi

kubectl create -f /work/provision/admin/kubernetes-dashboard.yaml
echo "Created kubernetes dashboard"
