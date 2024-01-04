# Intro


## connect to etcd using CLI

To simplify CLI, we use environment variables for etcdctl global options:

    export ETCDCTL_DIAL_TIMEOUT=3s
    export ETCDCTL_CACERT=/etc/kubernetes/pki/etcd/ca.crt
    export ETCDCTL_CERT=/etc/kubernetes/pki/apiserver-etcd-client.crt
    export ETCDCTL_KEY=/etc/kubernetes/pki/apiserver-etcd-client.key

## enable etcd encryption

Kubernetes stores API objects into etcd unencrypted by default.

You may selectively encrypt API objects by type using the AES etc.
The argument --encryption-provider-config should be set on kube-apiserver
to point to a config file like:

    ---
    apiVersion: apiserver.config.k8s.io/v1
    kind: EncryptionConfiguration
    resources:
      - resources:
          - secrets
          - configmaps
        providers:
          - aescbc:
              keys:
                - name: key1
                  # See the following text for more details about the secret value
                  secret: <BASE 64 ENCODED SECRET>
          - identity: {} # this fallback allows reading unencrypted secrets;
                         # for example, during initial migration

## instruct kube-apiserver to enable etcd encryption

The startup argument `--encryption-provider-config` should be set on
kube-apiserver. It is recommended that placing the aforementioned config file
into a dedicated directory, say, /etc/kubernetes/etcd. And you should
use `hostPath` to map this directory into the container of kube-apiserver,
otherwise, it can't read the configuration and the kube-apiserver will fail
to start.

## Trigger encryption of existing secrets

As the encryption setting only applies to new secrets, you have to recreate
existing secrets so that they will be encrypted as well. You can achieve this goal
by executing a single command like:

    kubectl get secrets -A -o yaml | kubectl replace -f -
