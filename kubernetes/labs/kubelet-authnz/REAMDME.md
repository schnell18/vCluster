# Summary

In kubeadm managed cluster, kubelet is set to authenticate and authorize any client request.
The kube-apiserver uses the `/etc/kuberenetes/kubelet/apiserver-kubelet-client.crt` to connect to kubelet. The certificate assigns the kube-apiserver `system:masters` group, which is a privilleged group assign with cluster-admin role.
    kubectl get clusterrolebinding -o yaml |grep -B 20 system:masters

    - apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRoleBinding
      metadata:
        annotations:
          rbac.authorization.kubernetes.io/autoupdate: "true"
        creationTimestamp: "2022-08-15T15:38:31Z"
        labels:
          kubernetes.io/bootstrapping: rbac-defaults
        name: cluster-admin
        resourceVersion: "140"
        uid: c40e650e-589c-4a18-89be-00d3012e84f9
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: cluster-admin
      subjects:
      - apiGroup: rbac.authorization.k8s.io
        kind: Group
        name: system:masters

    kubectl get clusterrole cluster-admin -o yaml

    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      annotations:
        rbac.authorization.kubernetes.io/autoupdate: "true"
      creationTimestamp: "2022-08-15T15:38:31Z"
      labels:
        kubernetes.io/bootstrapping: rbac-defaults
      name: cluster-admin
      resourceVersion: "78"
      uid: 072b0b95-dabd-4157-9b68-184c4f0c4bd5
    rules:
    - apiGroups:
      - '*'
      resources:
      - '*'
      verbs:
      - '*'
    - nonResourceURLs:
      - '*'
      verbs:
      - '*'

