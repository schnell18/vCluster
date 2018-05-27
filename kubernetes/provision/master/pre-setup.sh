# expect MINION_COUNT KUBERNETES_PUBLIC_ADDRESS

KUBE_DATA_DIR=/var/lib/kubernetes
TEMP_DATA_DIR=/tmp/kubernetes

# create directories
if [ ! -d $KUBE_DATA_DIR ]; then
  mkdir -p $KUBE_DATA_DIR
fi

if [ ! -d $TEMP_DATA_DIR ]; then
  mkdir -p $TEMP_DATA_DIR
fi

if [ ! -f $KUBE_DATA_DIR/ca.pem ]; then
  echo "Generating ca, certs and kubeconfig..."

cat << EOF | cfssl gencert -initca - | cfssljson -bare $KUBE_DATA_DIR/ca
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Shanghai",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Shanghai"
    }
  ]
}
EOF

cat << EOF > $TEMP_DATA_DIR/ca-config.json
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

# generate certificates for apiserver
cat > $TEMP_DATA_DIR/kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Shanghai",
      "O": "Kubernetes",
      "OU": "jjhome",
      "ST": "Shanghai"
    }
  ]
}
EOF

cfssl gencert \
  -ca=$KUBE_DATA_DIR/ca.pem \
  -ca-key=$KUBE_DATA_DIR/ca-key.pem \
  -config=$TEMP_DATA_DIR/ca-config.json \
  -hostname=10.200.0.10,10.32.0.1,10.200.0.11,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  $TEMP_DATA_DIR/kubernetes-csr.json | cfssljson -bare $KUBE_DATA_DIR/kubernetes

# generate certifcate for kube-scheduler
cat > /tmp/kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Shanghai",
      "O": "system:kube-scheduler",
      "OU": "jjhome",
      "ST": "Shanghai"
    }
  ]
}
EOF

cfssl gencert \
  -ca=$KUBE_DATA_DIR/ca.pem \
  -ca-key=$KUBE_DATA_DIR/ca-key.pem \
  -config=$TEMP_DATA_DIR/ca-config.json \
  -profile=kubernetes \
  /tmp/kube-scheduler-csr.json | cfssljson -bare $KUBE_DATA_DIR/kube-scheduler

kubectl config set-cluster my-kube \
  --certificate-authority=$KUBE_DATA_DIR/ca.pem \
  --embed-certs=true \
  --server=https://$KUBERNETES_PUBLIC_ADDRESS:6443 \
  --kubeconfig=$KUBE_DATA_DIR/kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
  --client-certificate=$KUBE_DATA_DIR/kube-scheduler.pem \
  --client-key=$KUBE_DATA_DIR/kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig=$KUBE_DATA_DIR/kube-scheduler.kubeconfig

kubectl config set-context default \
  --cluster=my-kube \
  --user=system:kube-scheduler \
  --kubeconfig=$KUBE_DATA_DIR/kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=$KUBE_DATA_DIR/kube-scheduler.kubeconfig

# generate certificate for kube-controller-manager
cat > /tmp/kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Shanghai",
      "O": "system:kube-controller-manager",
      "OU": "jjhome",
      "ST": "Shanghai"
    }
  ]
}
EOF

cfssl gencert \
  -ca=$KUBE_DATA_DIR/ca.pem \
  -ca-key=$KUBE_DATA_DIR/ca-key.pem \
  -config=$TEMP_DATA_DIR/ca-config.json \
  -profile=kubernetes \
  /tmp/kube-controller-manager-csr.json | cfssljson -bare $KUBE_DATA_DIR/kube-controller-manager

kubectl config set-cluster my-kube \
  --certificate-authority=$KUBE_DATA_DIR/ca.pem \
  --embed-certs=true \
  --server=https://$KUBERNETES_PUBLIC_ADDRESS:6443 \
  --kubeconfig=$KUBE_DATA_DIR/kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=$KUBE_DATA_DIR/kube-controller-manager.pem \
  --client-key=$KUBE_DATA_DIR/kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=$KUBE_DATA_DIR/kube-controller-manager.kubeconfig

kubectl config set-context default \
  --cluster=my-kube \
  --user=system:kube-controller-manager \
  --kubeconfig=$KUBE_DATA_DIR/kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=$KUBE_DATA_DIR/kube-controller-manager.kubeconfig

# generate certificates for service-account
cat > $TEMP_DATA_DIR/service-account-csr.json << EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Shanghai",
      "O": "Kubernetes",
      "OU": "jjhome",
      "ST": "Shanghai"
    }
  ]
}
EOF

cfssl gencert \
  -ca=$KUBE_DATA_DIR/ca.pem \
  -ca-key=$KUBE_DATA_DIR/ca-key.pem \
  -config=$TEMP_DATA_DIR/ca-config.json \
  -profile=kubernetes \
  $TEMP_DATA_DIR/service-account-csr.json | cfssljson -bare $KUBE_DATA_DIR/service-account

# setup admin kubeconfig
cat > $TEMP_DATA_DIR/admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Shanghai",
      "O": "system:masters",
      "OU": "jjhome",
      "ST": "Shanghai"
    }
  ]
}
EOF

cfssl gencert \
  -ca=$KUBE_DATA_DIR/ca.pem \
  -ca-key=$KUBE_DATA_DIR/ca-key.pem \
  -config=$TEMP_DATA_DIR/ca-config.json \
  -profile=kubernetes \
  $TEMP_DATA_DIR/admin-csr.json | cfssljson -bare $TEMP_DATA_DIR/admin

kubectl config set-cluster my-kube \
  --certificate-authority=$KUBE_DATA_DIR/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
  --kubeconfig=$TEMP_DATA_DIR/admin.kubeconfig

kubectl config set-credentials admin \
  --client-certificate=$TEMP_DATA_DIR/admin.pem \
  --client-key=$TEMP_DATA_DIR/admin-key.pem \
  --embed-certs=true \
  --kubeconfig=$TEMP_DATA_DIR/admin.kubeconfig

kubectl config set-context default \
  --cluster=my-kube \
  --user=admin \
  --kubeconfig=$TEMP_DATA_DIR/admin.kubeconfig

kubectl config use-context default --kubeconfig=$TEMP_DATA_DIR/admin.kubeconfig
if [ ! -d ~root/.kube ]; then
   mkdir -p ~root/.kube
fi
cp $TEMP_DATA_DIR/admin.kubeconfig ~root/.kube/config

if [ ! -d ~devel/.kube ]; then
   mkdir -p ~devel/.kube
fi
cp $TEMP_DATA_DIR/admin.kubeconfig ~devel/.kube/config
chown devel.devel ~devel/.kube/config

# generate certs for minions
for n in $(seq 1 $MINION_COUNT); do

  instance=kbn${n}.kube.vn
cat > $TEMP_DATA_DIR/${instance}-csr.json << EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Shanghai",
      "O": "system:nodes",
      "OU": "jjhome",
      "ST": "Shanghai"
    }
  ]
}
EOF

  EXTERNAL_IP=192.168.90.$(expr $n + 25)
  INTERNAL_IP=192.168.90.$(expr $n + 25)

  cfssl gencert \
    -ca=$KUBE_DATA_DIR/ca.pem \
    -ca-key=$KUBE_DATA_DIR/ca-key.pem \
    -config=$TEMP_DATA_DIR/ca-config.json \
    -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
    -profile=kubernetes \
    $TEMP_DATA_DIR/${instance}-csr.json | cfssljson -bare $TEMP_DATA_DIR/${instance}

  kubectl config set-cluster my-kube \
    --certificate-authority=$KUBE_DATA_DIR/ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=$TEMP_DATA_DIR/${instance}.kubeconfig

  kubectl config set-credentials system:node:${instance} \
    --client-certificate=$TEMP_DATA_DIR/${instance}.pem \
    --client-key=$TEMP_DATA_DIR/${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=$TEMP_DATA_DIR/${instance}.kubeconfig

  kubectl config set-context default \
    --cluster=my-kube \
    --user=system:node:${instance} \
    --kubeconfig=$TEMP_DATA_DIR/${instance}.kubeconfig

  kubectl config use-context default --kubeconfig=$TEMP_DATA_DIR/${instance}.kubeconfig

done

cat > $TEMP_DATA_DIR/kube-proxy-csr.json << EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "L": "Shanghai",
      "O": "system:node-proxier",
      "OU": "jjhome",
      "ST": "Shanghai"
    }
  ]
}
EOF

cfssl gencert \
  -ca=$KUBE_DATA_DIR/ca.pem \
  -ca-key=$KUBE_DATA_DIR/ca-key.pem \
  -config=$TEMP_DATA_DIR/ca-config.json \
  -profile=kubernetes \
  $TEMP_DATA_DIR/kube-proxy-csr.json | cfssljson -bare $TEMP_DATA_DIR/kube-proxy

kubectl config set-cluster my-kube \
  --certificate-authority=$KUBE_DATA_DIR/ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
  --kubeconfig=$TEMP_DATA_DIR/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
  --client-certificate=$TEMP_DATA_DIR/kube-proxy.pem \
  --client-key=$TEMP_DATA_DIR/kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=$TEMP_DATA_DIR/kube-proxy.kubeconfig

kubectl config set-context default \
  --cluster=my-kube \
  --user=system:kube-proxy \
  --kubeconfig=$TEMP_DATA_DIR/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=$TEMP_DATA_DIR/kube-proxy.kubeconfig
fi

# config etcd
cp -f $KUBE_DATA_DIR/kubernetes.pem /etc/etcd/
cp -f $KUBE_DATA_DIR/kubernetes-key.pem /etc/etcd/
cp -f $KUBE_DATA_DIR/ca.pem /etc/etcd/
chown etcd.etcd /etc/etcd/*.pem

sed -i 's%#ETCD_CERT_FILE=""%ETCD_CERT_FILE="/etc/etcd/kubernetes.pem"%' /etc/etcd/etcd.conf
sed -i 's%#ETCD_KEY_FILE=""%ETCD_KEY_FILE="/etc/etcd/kubernetes-key.pem"%' /etc/etcd/etcd.conf
sed -i 's%#ETCD_CLIENT_CERT_AUTH="false"%ETCD_CLIENT_CERT_AUTH="true"%' /etc/etcd/etcd.conf
sed -i 's%#ETCD_TRUSTED_CA_FILE=""%ETCD_TRUSTED_CA_FILE="/etc/etcd/ca.pem"%' /etc/etcd/etcd.conf
sed -i 's%#ETCD_PEER_CERT_FILE=""%ETCD_PEER_CERT_FILE="/etc/etcd/kubernetes.pem"%' /etc/etcd/etcd.conf
sed -i 's%#ETCD_PEER_KEY_FILE=""%ETCD_PEER_KEY_FILE="/etc/etcd/kubernetes-key.pem"%' /etc/etcd/etcd.conf
sed -i 's%#ETCD_PEER_CLIENT_CERT_AUTH=""false"%ETCD_PEER_CLIENT_CERT_AUTH="true"%' /etc/etcd/etcd.conf
sed -i 's%#ETCD_PEER_TRUSTED_CA_FILE="%ETCD_PEER_TRUSTED_CA_FILE="/etc/etcd/ca.pem"%' /etc/etcd/etcd.conf
sed -i 's%ETCD_LISTEN_CLIENT_URLS="http://localhost:2379"%ETCD_LISTEN_CLIENT_URLS="https://0.0.0.0:2379"%'  /etc/etcd/etcd.conf
