NODES=(
    slave-1.kube.vn
    slave-2.kube.vn
    slave-3.kube.vn
    slave-4.kube.vn)
for NODE in ${NODES[*]}; do
  scp -r profiles/ $NODE:/tmp
  ssh $NODE 'sudo mkdir -p /var/lib/kubelet/seccomp/profiles && sudo cp /tmp/profiles/*.json /var/lib/kubelet/seccomp/profiles'
done

