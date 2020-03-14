found=$(kubectl get storageclass/{{ storage_class_name }})

if [ -z $found ]; then
  cat <<EOF | kubectl apply -f -
{{ lookup('file', 'local-storage-class.yaml') }}
EOF
  echo "Created local-storage class"
fi