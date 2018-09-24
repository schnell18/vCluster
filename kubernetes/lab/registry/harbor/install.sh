# create pv & pvc
kubectl apply -f pv/log.pv.yaml
kubectl apply -f pv/registry.pv.yaml
kubectl apply -f pv/storage.pv.yaml
kubectl apply -f pv/log.pvc.yaml
kubectl apply -f pv/registry.pvc.yaml
kubectl apply -f pv/storage.pvc.yaml

# create config map
kubectl apply -f jobservice/jobservice.cm.yaml
kubectl apply -f mysql/mysql.cm.yaml
kubectl apply -f registry/registry.cm.yaml
kubectl apply -f ui/ui.cm.yaml
kubectl apply -f adminserver/adminserver.cm.yaml

# create service
kubectl apply -f jobservice/jobservice.svc.yaml
kubectl apply -f mysql/mysql.svc.yaml
kubectl apply -f registry/registry.svc.yaml
kubectl apply -f ui/ui.svc.yaml
kubectl apply -f adminserver/adminserver.svc.yaml

# create k8s deployment
kubectl apply -f registry/registry.deploy.yaml
kubectl apply -f mysql/mysql.deploy.yaml
kubectl apply -f jobservice/jobservice.deploy.yaml
kubectl apply -f ui/ui.deploy.yaml
kubectl apply -f adminserver/adminserver.deploy.yaml

# create k8s ingress
kubectl apply -f ingress.yaml
