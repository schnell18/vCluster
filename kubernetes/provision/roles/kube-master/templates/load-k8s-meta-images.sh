{% raw %}
found=$(docker images --format "{{.Repository}}" | grep kube-apiserver)
if [ -z $found ] && [ -f /work/.preload/k8s-meta-images.tar ]; then
    docker load < /work/.preload/k8s-meta-images.tar
    if [ $? -eq 0 ]; then
        echo "Loaded k8s meta images"
    else
        echo "Fail to load k8s meta images!!!"
        exit 1
    fi
fi
{% endraw %}
