
echo "Starting services..."
for SERVICE in nfs ntpd etcd kube-apiserver kube-controller-manager kube-scheduler; do
    systemctl daemon-reload
    systemctl enable $SERVICE
    systemctl restart $SERVICE
done

echo "Take a nap to wait for kube-apiserver fully started ..."
# take nap to wait for kube-apiserver fully started
sleep 20
echo "Creating RBAC rules..."
cat << EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF

cat << EOF | kubectl create -f -
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF

echo "Loading root-ca certificates into secret..."
kubectl create secret generic root-ca-certs                 \
  --from-file=tls-ca-bundle.pem=/var/lib/kubernetes/ca.pem  \
  --namespace kube-system

echo "Loading etcd key, certificates and ca into secret..."
kubectl create secret generic calico-etcd-secrets             \
  --from-file=etcd-cert=/var/lib/kubernetes/kubernetes.pem    \
  --from-file=etcd-key=/var/lib/kubernetes/kubernetes-key.pem \
  --from-file=etcd-ca=/var/lib/kubernetes/ca.pem              \
  --namespace kube-system

echo "Setup calico networking..."
kubectl create -f /work/provision/network/calico/rbac.yaml
kubectl create -f /work/provision/network/calico/calico.yaml

echo "Setup kube-dns..."
kubectl create -f /work/provision/network/dns/kube-dns.yaml