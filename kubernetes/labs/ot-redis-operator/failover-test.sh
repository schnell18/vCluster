# create a simple kv pair
kubectl -n caching exec -it redis-cluster-leader-0 \
    -- bash -c "export REDISCLI_AUTH='Opstree@1234'; redis-cli -c set email abc@xyz.com"

# retrieve the kv pair
kubectl -n caching exec -it redis-cluster-leader-0 \
    -- bash -c "export REDISCLI_AUTH='Opstree@1234'; redis-cli -c get email"

# remove on master node
kubectl -n caching delete pod redis-cluster-leader-0

# check cluster failover
kubectl -n caching exec -it redis-cluster-leader-0 \
    -- bash -c "export REDISCLI_AUTH='Opstree@1234'; redis-cli cluster nodes"
