kubectl run ephemeral-demo --image=registry.k8s.io/pause:3.9 --restart=Never

kubectl exec -it ephemeral-demo -- sh

kubectl debug -it ephemeral-demo --image=busybox:1.28 --target=ephemeral-demo

kubectl describe pod ephemeral-demo


# explore the copy feature

kubectl run myapp --image=docker.io/library/busybox:1.28 --restart=Never -- sleep 1d
kubectl debug myapp -it --image=docker.io/library/ubuntu:noble --share-processes --copy-to=myapp-debug

# change command

kubectl run myapp --image=docker.io/library/busybox:1.28 --restart=Never -- false
kubectl debug myapp -it --copy-to=myapp-debug --container=myapp -- sh


# debug node

kubectl debug node/slave-1 -it --image=docker.io/library/ubuntu:noble -- bash
# host file system is under /host
