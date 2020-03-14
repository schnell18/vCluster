{% raw %}
found=$(docker images --format "{{.Repository}}" | grep kube-proxy)
if [ -z $found ]; then
    docker load < /work/.preload/k8s-meta-images.tar
    if [ $? -eq 0 ]; then
        echo "Loaded k8s meta images"
    else
        echo "Fail to k8s meta images!!!"
        exit 1
    fi
fi
{% endraw %}
