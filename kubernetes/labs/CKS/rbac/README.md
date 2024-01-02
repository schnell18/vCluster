# intro

Explore RBAC in kubernetes.

## experiment 1 -- restrict access to certain namespace

Create two namespaces:

- prod
- test

User `test` has access to secret in the test namespace, but not the prod
namespace.

    kubectl create namespace prod
    kubectl create namespace test

Create role `secret-manager`:

    kubectl -n prod create role secret-manager --verb=get --resource=secrets
    kubectl -n prod create rolebinding secret-manager --role=secret-manager --user=test

    kubectl -n test create role secret-manager --verb=get --verb=list --resource=secrets
    kubectl -n test create rolebinding secret-manager --role=secret-manager --user=test

Check permission:

    kubectl -n prod auth can-i get secrets --as test
    kubectl -n test auth can-i get secrets --as test

## experiment 2 -- administrative roles to manage deployments

Make user `superadmin` able to delete deployments in all namespaces.

    kubectl create clusterrole delete --verb=delete --resource=deployment
    kubectl create clusterrolebinding delete --clusterrole=delete --user=superadmin

Make user `simpleadmin` able to delete deployments in prod namespaces.

    kubectl -n prod create rolebinding delete --clusterrole=delete --user=simpleadmin

Check permission:

    kubectl auth can-i delete deployments --as superadmin
    kubectl -n prod auth can-i delete deployments --as simpleadmin

## setup normal user in kubernetes

Normal user is represented by certificate in kubernetes. To setup normal user,
you have to:

- generate key and CSR
- sign CSR using kubernetes

### generate key and CSR

Make sure you have openssl installed and run:

    openssl genrsa -out user1.key 2048
    openssl req -new -key user1.key -out user1.csr

Set the common name properly as it identify the user in kubernetes.

Create CSR:

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: user1
spec:
  request: $(cat user1.csr | base64 | tr -d "\n")
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400  # one day
  usages:
  - client auth
EOF


### sign CSR

    kubectl certificate approve user1
    kubectl get csr user1 -o jsonpath='{.status.certificate}'| base64 -d > user1.crt
