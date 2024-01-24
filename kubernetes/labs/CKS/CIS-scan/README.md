# introduction

The CIS kubernetes recommendation 4.2.1 sugguests forbidding anonymous access.
However, Disabling anonymous user prevents node join cluster using kubeadm as
it need request anonymously the cluster-info which is stored in the kube-public
namespace as a configmap .

## Experiment 1: check master for CIS vulnerabilities

Run this command and wait the completion of job:

    kubectl apply -f kube-bench-master.yaml

Then examine the log of the job:

    kubectl logs kube-bench-***** > scan-master-1.28.5.log

Replace the stars with the actual chars in your experiment.

You should find only 2 failures reported:

    [FAIL] 1.1.12 Ensure that the etcd data directory ownership is set to etcd:etcd (Automated)
    [FAIL] 1.2.5 Ensure that the --kubelet-certificate-authority argument is set as appropriate (Automated)

## Experiment 2: check worker node for CIS vulnerabilities

Run this command and wait the completion of job:

    kubectl apply -f kube-bench-node.yaml

Then examine the log of the job:

    kubectl logs kube-bench-worker-***** > scan-worker-1.28.5.log

Replace the stars with the actual chars in your experiment.
You should find no failures reported.
