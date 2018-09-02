kubectl create secret generic traefik-cert \
  --from-file=tls.crt=traefik.pem \
  --from-file=tls.key=traefik-key.pem