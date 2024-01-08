# Introduction

Explores Kyverno, which does not requires knowing configuration language.
For complex policy examples, see the [kyverno policies project][2].

## Install kyverno

Run this command:

    kubectl create -f install.yaml

where `create` can't be replaced with `apply`, otherwise errors such as:

    error when creating "install.yaml":
    CustomResourceDefinition.apiextensions.k8s.io "clusterpolicies.kyverno.io" is
    invalid: metadata.annotations: Too long: must have at most 262144 bytes

will be raised.

The `install.yaml` file is a copy of [the v1.11.1 on official site][1].

## Experiment 1 -- validate team label is set on Pod

Mandate every Pod has the `team` label defined.

Steps:
- create the policy:

    kubectl apply -f validate-team-label.yaml

- create a deploy without the required label:

    kubectl create deployment nginx --image=docker.io/library/nginx:1.24.0-bullseye-perl

  an error should be displayed.

- review the report:

    kubectl get policyreport -o wide

- create a deploy with the required label:

    kubectl run nginx --image=docker.io/library/nginx:1.24.0-bullseye-perl --labels team=tiger

  an error should be displayed.

- review the report:

    kubectl get policyreport -o wide

## Experiment 2 -- add team label to Pod w/o this label

Use mutation to add the `team` label to Pod which doesn't define this label.

Steps:
- create the policy:

    kubectl apply -f add-team-label.yaml

- create a pod without the team label:

    kubectl run redis --image=docker.io/bitnami/redis:6.2.6
    kubectl get pods --show-labels

The team label should be assigned with `bravo` as value.

- create a pod without the team label:

    kubectl run newredis --image=docker.io/bitnami/redis:6.2.6 --labels team=alpha
    kubectl get pods --show-labels

The team label should be assigned with `alpha` as value.

Cleanup:

    kubectl delete pods redis --force
    kubectl delete pods newredis --force
    kubectl delete clusterpolicy add-labels require-labels

## Experiment 3 -- synchronize image pull secret using generation

Steps:

- create a seed image pull secret in the `default` namespace:

    kubectl -n default create secret docker-registry regcred \
      --docker-server=dev.tinker.com \
      --docker-username=john.doe \
      --docker-password=Passw0rd123! \
      --docker-email=john.doe@tinker.com

- create the sync policy:

    kubectl apply -f sync-secrets.yaml

- create a new namespace and inspect the image pull secret:

    kubectl create ns myns01
    kubectl -n myns01 get secrets

cleanup:

    kubectl delete secret regcred
    kubectl delete clusterpolicy sync-secrets
    kubectl delete namespace myns01 --force

[1]: https://github.com/kyverno/kyverno/releases/download/v1.11.1/install.yaml
[2]: https://github.com/kyverno/policies
