# Explore ingress

We explore the [nginx ingress controller][1] in this lab.

Install with yaml:

    kubectl apply -f deployment.yaml

The `deployment.yaml` is a copy of [ingress-nginx v1.8.2][2]

## simple ingress to expose web1 and web2

kubectl apply -f simple-ingress.yaml

## secure ingress by setting TLS certificate

Obtain a real TLS certificate and key or generate a self-signed one to
simulate:

    openssl req -x509 \
        -newkey rsa:4096 \
        -keyout kube-vn.key \
        -out kube-vn.crt \
        -days 365 -nodes

Encapsulate the above key and certificate into a secret:

    kubectl create secret min-ingress-tls --key kube-vn.key --cert kube-vn.crt

Assoicate the ingress object with the tls secret:

    spec:
      tls:
      - hosts:
          - entry.kube.vn
        secretName: min-ingress-tls

[1]: https://github.com/kubernetes/ingress-nginx
[2]: https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
