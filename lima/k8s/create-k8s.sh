#!/bin/bash

# limactl start \
#   --name=k8s \
#   --cpus=6 \
#   --memory=8 \
#   --vm-type=vz \
#   --rosetta \
#   --mount-type=virtiofs \
#   --mount-writable \
#   --network=vzNAT \
#   template://k8s

limactl start k8s.yaml
