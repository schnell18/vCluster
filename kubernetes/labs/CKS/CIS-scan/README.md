# introduction

The CIS kubernetes recommendation 4.2.1 sugguests forbidding anonymous access.
However, Disabling anonymous user prevents node join cluster using kubeadm as
it need request anonymously the cluster-info which is stored in the kube-public
namespace as a configmap .

