NODES=(
    slave-1.kube.vn
    slave-2.kube.vn
    slave-3.kube.vn
    slave-4.kube.vn)
for NODE in ${NODES[*]}; do ssh $NODE 'sudo apt-get install -y apparmor-utils && sudo apparmor_parser -q <<EOF
include <tunables/global>

profile k8s-deny-write flags=(attach_disconnected) {
  include <abstractions/base>

  file,

  # Deny all file writes.
  deny /** w,
}
EOF'
done

