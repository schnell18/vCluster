CLUSTER_IP=$(kubectl get svc -lapp=cassandra -o jsonpath='{.items[0].spec.clusterIP}')
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: cqlsh2
  labels:
    run: cqlsh2
spec:
  volumes:
    - name: work-vol
      hostPath:
        path: /work
        type: Directory
  containers:
    - name: cqlsh2
      image: 'cassandra:3.11'
      args:
        - cqlsh
        - ${CLUSTER_IP}
      volumeMounts:
        - name: work-vol
          mountPath: /work
      stdin: true
      stdinOnce: true
      tty: true
EOF
kubectl attach cqlsh2 -c cqlsh2 -it

# use kubectl run --overrides to mount hostPath dose not work
# kubectl run cqlsh \
#    -it \
#    --generator=run-pod/v1 \
#    --overrides='{"apiVersion":"v1","kind":"Pod","spec":{"containers":[{"name":"cqlsh2","image":"cassandra:3.11","volumeMounts":[{"mountPath":"/work","name":"work-vol"}]}],"volumes":[{"name":"work-vol","hostPath":{"path":"/work","type":"Directory"}}]}}' \
#    --rm=true \
#    --image=cassandra:3.11 \
#    cqlsh $CLUSTER_IP


# {
#     "apiVersion": "v1",
#     "kind": "Pod",
#     "spec": {
#         "containers" : [
#             {
#                 "name": "cqlsh2",
#                 "image": "cassandra:3.11",
#                 "volumeMounts": [
#                     {
#                         "mountPath": "/work",
#                         "name": "work-vol"
#                     }
#                 ]
#             }
#         ],
#         "volumes" : [
#             {
#                 "name": "work-vol",
#                 "hostPath": {
#                     "path": "/work",
#                     "type": "Directory"
#                 }
#             }
#         ]
#     }
# }