kubectl get clusterrole
kubectl describe clusterrole system:kube-dns
kubectl get clusterrolebinding
kubectl describe clusterrolebinding system:kube-dns
kubectl -n kube-system create serviceaccount kube-dns
TOKEN="$(kubectl -n kube-system get secret kube-dns-token-rkd2v -o jsonpath='{$.data.token}' | base64 -d)"

curl -kD - -H "Authorization: Bearer $TOKEN" https://kbm1.kube.vn:6443/api/v1/services
curl -kD - -H "Authorization: Bearer $TOKEN" https://kbm1.kubee.vn:6443/api/v1/pods

kubectl describe clusterrole system:node

kubectl create secret generic mysecret --from-literal=foo=bar
kubectl run nginx --image=nginx:alpine --restart='Never' \
   --overrides='{"apiVersion": "v1", "spec": {"volumes": [{"name": "secretvol", "secret": {"secretName": "mysecret"}}]}}'

# try from unauthorized node
curl -kD - \
   --cacert /work/setup_manually/pki/run/ca.pem \
   --cert /work/setup_manually/pki/run/kbn2.kube.vn.pem \
   --key /work/setup_manually/pki/run/kbn2.kube.vn-key.pem \
   https://kbm1.kube.vn:6443/api/v1/namespaces/deault/secrets/mysecret

# try from authorized node
curl -kD - \
   --cacert /work/setup_manually/pki/run/ca.pem \
   --cert /work/setup_manually/pki/run/kbn1.kube.vn.pem \
   --key /work/setup_manually/pki/run/kbn1.kube.vn-key.pem \
   https://kbm1.kube.vn:6443/api/v1/namespaces/deault/secrets/mysecret
