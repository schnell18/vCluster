CLUSTER_IP=$(kubectl get svc -lapp=cassandra -o jsonpath='{.items[0].spec.clusterIP}')

# use kubectl run --overrides to mount hostPath dose not work
kubectl run cqlsh \
   -it \
   -lrole=devShell \
   --generator=run-pod/v1 \
   --rm=true \
   --image=cassandra:3.11 \
   cqlsh $CLUSTER_IP
