k run web1 --image=docker.io/library/nginx:1.24.0-bullseye-perl
k run web2 --image=docker.io/library/httpd:2.4.58
k expose po web1 --port=80
k expose po web2 --port=80

k exec -it web1 -- curl localhost


# enable web1 <=> web2 traffics

cat<<EOF | k apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web-conn-policy
  namespace: default
spec:
  podSelector:
    matchExpressions:
    - key: run
      operator: In
      values: ["web1", "web2"]
  policyTypes:
    - Ingress
    - Egress
  ingress:
    - from:
        - podSelector:
            matchExpressions:
            - key: run
              operator: In
              values: ["web1", "web2"]
      ports:
        - protocol: TCP
          port: 80
  egress:
    - to:
        - podSelector:
            matchExpressions:
            - key: run
              operator: In
              values: ["web1", "web2"]
      ports:
        - protocol: TCP
          port: 80
EOF
