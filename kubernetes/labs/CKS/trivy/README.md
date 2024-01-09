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

Similar to above, output result in json for further processing(eg. visualize in
[trivy-vulnerability-explorer][3]):

    trivy image -f json --severity UNKNOWN,MEDIUM,HIGH,CRITICAL --scanners vuln,misconfig,secret,license docker.io/library/python:3.4-alpine


## scan kubernetes cluster

To scan kubernetes cluster:

    trivy k8s --report summary cluster

To scan kubernetes cluster for specific namespace:

    trivy k8s -n kube-system --report summary cluster

You can automate the scanning task using the [trivy operator][2] or similar
tool [zora][4].

## scan specific kubernetes objects

You can scope the objects to scan by using:

- kubernetes kind: pod, deployment, configmap etc
- pods/xxx, deployments/yyy
- all

The following command:

    trivy k8s -n kube-system --report summary pods

scans pods in kube-system namespace for vulnerabilities.




[1]: https://aquasecurity.github.io/trivy
[2]: https://aquasecurity.github.io/trivy-operator/latest/
[3]: https://github.com/dbsystel/trivy-vulnerability-explorer
[4]: https://zora-docs.undistro.io/latest/
