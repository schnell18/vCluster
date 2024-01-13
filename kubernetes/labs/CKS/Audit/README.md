# Audit

Kubernetes audit logs are crucial to trouble shooting, monitoring and forensic.
However, it is not enabled by default.
The audit logs record the requests to the Kubernetes API Server. The API request
include four stages:

- RequestReceived: The stage for events generated as soon as the audit handler
  receives the request, and before it is delegated down the handler chain.

- ResponseStarted: Once the response headers are sent, but before the response
  body is sent. This stage is only generated for long-running requests(eg watch).

- ResponseComplete: The response body has been completed and no more bytes will
  be sent.

- Panic: Events generated when a panic occurred.

Content of log can be one of four options:

- None: don't log events that match this rule.

- Metadata: log request metadata(requesting user, timestamp, resource, verb
  etc) but not request or response body.

- Request: log event metadata and request body but not response body. This does
  not apply for non-resource requests.

- RequestResponse: log event metadata, request and response bodies. This does
  not apply for non-resource requests.


## enable audit

- add api-server startup arguments (audit-policy-file, audit-log-path,
  audit-log-maxage, audit-log-maxsize, audit-log-maxbackup)
- prepare an audit policy file
- restart api-server

A mininal audit policy file is as follows:

    apiVersion: audit.k8s.io/v1
    kind: Policy
    rules:
    - level: Metadata

Please note, if you run the api-server as static pod, then you need mount
policy file as well as the audit log into the container, for example:

  volumes:
  - hostPath:
      path: /etc/kubernetes/audit
      type: DirectoryOrCreate
    name: k8s-aduit-conf-dir
  - hostPath:
      path: /var/log/k8s
      type: DirectoryOrCreate
    name: k8s-aduit-log-dir

The volume `k8s-audit-conf-dir` mounts the host path `/etc/kubernetes/audit`
into the container. Likewise, the volume `k8s-audit-log-dir` mounts the host
path `/var/log/k8s` into the container.

## Experiment 1 - Create a generic secret and check audit log

Create a generic secret as follows:

    kubectl create secret generic the-top-secret \
        --from-literal=user=justin \
        --from-literal=pass=topsecret

Run this command to check audit log:

    grep the-top-secret /var/log/k8s/audit.log

You should get output similar to message as follows:

    {
      "kind": "Event",
      "apiVersion": "audit.k8s.io/v1",
      "level": "Metadata",
      "auditID": "d87c9a71-52b1-4446-94b8-a295be8f75da",
      "stage": "ResponseComplete",
      "requestURI": "/api/v1/namespaces/default/secrets?fieldManager=kubectl-create&fieldValidation=Strict",
      "verb": "create",
      "user": {
        "username": "kubernetes-admin",
        "groups": [
          "system:masters",
          "system:authenticated"
        ]
      },
      "sourceIPs": [
        "192.168.56.1"
      ],
      "userAgent": "kubectl/v1.27.2 (darwin/amd64) kubernetes/7f6f68f",
      "objectRef": {
        "resource": "secrets",
        "namespace": "default",
        "name": "the-top-secret",
        "apiVersion": "v1"
      },
      "responseStatus": {
        "metadata": {},
        "code": 201
      },
      "requestReceivedTimestamp": "2024-01-13T09:15:31.345717Z",
      "stageTimestamp": "2024-01-13T09:15:31.352705Z",
      "annotations": {
        "authorization.k8s.io/decision": "allow",
        "authorization.k8s.io/reason": ""
      }
    }


