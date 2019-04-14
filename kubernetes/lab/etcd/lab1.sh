for i in $(seq 10); do
    etcdctl put foo$i bar$i
done

etcdctl endpoint status -w table 
etcdctl get revisiontestkey -w json 
