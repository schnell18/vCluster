kubectl -n monitoring wait --for=condition=Ready pods -l  app.kubernetes.io/name=prometheus-operator
