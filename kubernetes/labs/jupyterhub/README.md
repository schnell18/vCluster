# Introduction

Explore how to setup juypterhub on kubernetes.

## Config helm

    helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
    helm repo update

## Prepare a config file

    # This file can update the JupyterHub Helm chart's default configuration values.
    #
    # For reference see the configuration reference and default values, but make
    # sure to refer to the Helm chart version of interest to you!
    #
    # Introduction to YAML:     https://www.youtube.com/watch?v=cdLNKUoMc6c
    # Chart config reference:   https://zero-to-jupyterhub.readthedocs.io/en/stable/resources/reference.html
    # Chart default values:     https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/HEAD/jupyterhub/values.yaml
    # Available chart versions: https://jupyterhub.github.io/helm-chart/
    #

## Deploy juypterhub using helm

    helm upgrade --cleanup-on-fail \
      --install juypterhub jupyterhub/jupyterhub \
      --namespace jupyterhub \
      --create-namespace \
      --version=2.0.0 \
      --values config.yaml
