# Introduction

Explore [trivy][1], the security scanning tool.
The trivy works with docker image, file system and kubernetes.


## scan container image

To scan the python:3.4-alpine image:

    trivy image python:3.4-alpine

To scan the python:3.4-alpine image for misconfiguration, license,
vulnerability and secret and report issues with severity equal to medium or
above:

    trivy image --severity UNKNOWN,MEDIUM,HIGH,CRITICAL --scanners vuln,misconfig,secret,license docker.io/library/python:3.4-alpine

Similar to above, output result in json for further processing:

    trivy image -f json --severity UNKNOWN,MEDIUM,HIGH,CRITICAL --scanners vuln,misconfig,secret,license docker.io/library/python:3.4-alpine


## scan kubernetes cluster

To scan kubernetes cluster:

    trivy k8s --report summary cluster

To scan kubernetes cluster for specific namespace:

    trivy k8s -n kube-system --report summary cluster

You can automate the scanning task using the [trivy operator][2].


[1]: https://aquasecurity.github.io/trivy
[2]: https://aquasecurity.github.io/trivy-operator/latest/
