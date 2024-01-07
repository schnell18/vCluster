# OPA gatekeeper

Expolore OPA gatekeeper.

[Comparison of OPA, Kyverno and jsPolicy][3]

## Install gatekeeper

Install the OPA gatekeeper:

    kubectl apply -f gatekeeper.yaml

The `gatekeeper.yaml` is a copy of [v3.14][1] of the gatekeeper project.

## Gatekeeper Library

The library contains comprehensive and reusable templates created by the
community. You may access it by following [this link][2].



[1]: https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.14.0/deploy/gatekeeper.yaml
[2]: https://open-policy-agent.github.io/gatekeeper-library/website/
[3]: https://opensource.com/article/23/2/kubernetes-policy-engines
