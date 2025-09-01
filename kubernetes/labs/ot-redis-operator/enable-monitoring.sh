helm upgrade redis-cluster ot-helm/redis-cluster -f monitoring-values.yaml \
  --set redisCluster.clusterSize=3 --install --namespace ot-redis

