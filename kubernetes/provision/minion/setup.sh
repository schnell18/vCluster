# expect: NODE_IP MASTER_HOST

CONTAINERD_CONF_DIR=/etc/containerd
KUBE_DATA_DIR=/var/lib/kubernetes
TEMP_DATA_DIR=/tmp/kubernetes
KUBE_PROXY_DATA_DIR=/var/lib/kube-proxy
KUBELET_DATA_DIR=/var/lib/kubelet
POD_CIDR=10.200.0.0/24
CLUSTER_CIDR=10.200.0.0/16

# create directories
mkdir -p $CONTAINERD_CONF_DIR
mkdir -p $KUBE_DATA_DIR
mkdir -p $KUBE_PROXY_DATA_DIR
mkdir -p $KUBELET_DATA_DIR

echo "Setting up containerd..."
# config containerd
cat << EOF > $CONTAINERD_CONF_DIR/config.toml
[plugins]
  [plugins.cri]
    stream_server_address = "$NODE_IP"
    stream_server_port = "10010"
    [plugins.cri.containerd]
      snapshotter = "overlayfs"
      [plugins.cri.containerd.default_runtime]
        runtime_type = "io.containerd.runtime.v1.linux"
        runtime_engine = "/usr/local/bin/runc"
        runtime_root = ""
      [plugins.cri.containerd.untrusted_workload_runtime]
        runtime_type = "io.containerd.runtime.v1.linux"
        runtime_engine = "/usr/local/bin/runc"
        runtime_root = "/run/containerd/runc"
    [plugins.cri.registry]
      [plugins.cri.registry.mirrors]
        [plugins.cri.registry.mirrors."docker.io"]
          endpoint = ["https://registry.docker-cn.com", "https://registry-1.docker.io"]

EOF

# Proxy only if you have gcr image to pull
echo "" > $CONTAINERD_CONF_DIR/env.lst
# cat << EOF > $CONTAINERD_CONF_DIR/env.lst
# HTTP_PROXY=192.168.90.1:1087
# HTTPS_PROXY=192.168.90.1:1087
# NO_PROXY=.docker-cn.com,.docker.io
# EOF

# generate containerd systemd unit file
cat << EOF > /etc/systemd/system/containerd.service
[Unit]
Description=containerd container runtime
Documentation=https://containerd.io
After=network.target

[Service]
EnvironmentFile=$CONTAINERD_CONF_DIR/env.lst
ExecStartPre=/sbin/modprobe overlay
ExecStart=/usr/local/bin/containerd
Restart=always
RestartSec=5
Delegate=yes
KillMode=process
OOMScoreAdjust=-999
LimitNOFILE=1048576
LimitNPROC=infinity
LimitCORE=infinity

[Install]
WantedBy=multi-user.target
EOF

echo "Copying certs and kubeconfig from master..."
# scp ca from master node
scp -o StrictHostKeyChecking=no $MASTER_HOST:$KUBE_DATA_DIR/ca.pem $KUBE_DATA_DIR
scp -o StrictHostKeyChecking=no $MASTER_HOST:$KUBE_DATA_DIR/ca-key.pem $KUBE_DATA_DIR

# scp kubelet and kube-proxy certificates from master node
HOSTNAME=$(hostname -f)
scp -o StrictHostKeyChecking=no $MASTER_HOST:$TEMP_DATA_DIR/${HOSTNAME}.pem $KUBELET_DATA_DIR
scp -o StrictHostKeyChecking=no $MASTER_HOST:$TEMP_DATA_DIR/${HOSTNAME}-key.pem $KUBELET_DATA_DIR
scp -o StrictHostKeyChecking=no $MASTER_HOST:$TEMP_DATA_DIR/kube-proxy.pem $KUBE_PROXY_DATA_DIR

# scp kubelet and kube-proxy kubeconfig from master node
scp -o StrictHostKeyChecking=no $MASTER_HOST:$TEMP_DATA_DIR/kube-proxy.kubeconfig $KUBE_PROXY_DATA_DIR/kubeconfig
scp -o StrictHostKeyChecking=no $MASTER_HOST:$TEMP_DATA_DIR/${HOSTNAME}.kubeconfig $KUBELET_DATA_DIR/kubeconfig


echo "Setting up kubelet ..."

# genereate kubelet systemd unit file
cat << EOF > /var/lib/kubelet/kubelet-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "${KUBE_DATA_DIR}/ca.pem"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.32.0.10"
podCIDR: "${POD_CIDR}"
runtimeRequestTimeout: "15m"
tlsCertFile: "${KUBELET_DATA_DIR}/${HOSTNAME}.pem"
tlsPrivateKeyFile: "${KUBELET_DATA_DIR}/${HOSTNAME}-key.pem"
EOF

cat << EOF > /etc/systemd/system/kubelet.service
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=containerd.service
Requires=containerd.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --config=${KUBELET_DATA_DIR}/kubelet-config.yaml \\
  --container-runtime=remote \\
  --container-runtime-endpoint=unix:///var/run/containerd/containerd.sock \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=${KUBELET_DATA_DIR}/kubeconfig \\
  --network-plugin=cni \\
  --register-node=true \\
  --allow-privileged \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

echo "Setting up kube-proxy ..."
# config kube-proxy
# generate kube-proxy config file
cat << EOF > $KUBE_PROXY_DATA_DIR/kube-proxy-config.yaml
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "$KUBE_PROXY_DATA_DIR/kubeconfig"
mode: "iptables"
clusterCIDR: "${CLUSTER_CIDR}"
EOF

# generate kube-proxy systemd unit file
cat << EOF > /etc/systemd/system/kube-proxy.service
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=$KUBE_PROXY_DATA_DIR/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
