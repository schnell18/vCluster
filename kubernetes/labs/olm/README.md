# Introduction

This document describes steps to install OLM.

Follow commands as shown below to install OLM:

    cd kubernetes/labs/olm
    apply -f bootstrap/crds.yaml
    apply -f bootstrap/olm.yaml

The OLM should be installed under the `operators` namespace.
The CRDs created by the OLM include:

- ClusterServiceVersion
- CatalogSource
- InstallPlan
- OperatorGroup
- Subscription

which can be retrieved by:

    kubectl get crd

Beside the CRDs, you should be able to see the deployments created by OLM by typing:

    kubectl get deploy -n olm

    catalog-operator   1/1     1            1           11d
    olm-operator       1/1     1            1           11d
    packageserver      2/2     2            2           11d

