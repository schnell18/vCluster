#!/bin/bash

kubectl -n caching apply -f cluster.yaml
# helm install redis-cluster ot-helm/redis-cluster \
#   --set redisCluster.clusterSize=3 --namespace caching \
#   -f monitoring-values.yaml

