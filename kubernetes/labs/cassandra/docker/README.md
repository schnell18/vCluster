# Introduction

This is a convenient docker image to adapt official cassandra docker
image to Kubernetes runtime.

## Build Docker image

If you wish to build the docker image from scratch, you may clone this
repository and choose appropriate sub directory containing Dockerfile
and run:

    docker build -t schnell18/cassandra:3.11.6
