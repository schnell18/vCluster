kubectl get deployment/kubernetes-dashboard -n kubernetes-dashboard
if [ $? -eq 0 ]; then
    exit 0
fi

cat <<EOF | kubectl apply -f -
{{ lookup('file', 'kubernetes-dashboard.yaml') }}
EOF
echo "Created kubernetes dashboard"
