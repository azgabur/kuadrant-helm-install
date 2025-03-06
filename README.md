# Helm chart for deploying Kuadrant and testing environment

This chart requires that your cluster has loadbalancing service.

# What is installed

- Kuadrant-operator
- Red Hat cert-manager
- Istio provider (one of)
  - Sail operator
  - Openshift service mesh v3
- Gateway API

If you choose to deploy testsuite:

- RH Keycloak
- Jaeger
- Mockserver
- `kuadrant` and `kuadrant2` namespaces with additionalManifests.yaml

# How to run

1. Set up values.yaml
2. Login to your cluster
3. Run:
```sh
./install.sh
```
4. Enjoy
5. Cleanup: `./uninstall.sh`

## Testsuite deploy and Environment variables

If you want an environment ready for running [Kuadrant testsuite](https://github.com/Kuadrant/testsuite) create additionalManifests.yaml with list of DNS provider credentials and Letsencrypt issuer. More info about required objects see [testsuite wiki](https://github.com/Kuadrant/testsuite/wiki/Guide-to-prepare-Openshift-cluster-to-run-testsuite)
Look at example-additionalManifests.yaml

Use `-t` flag to get Kuadrant testsuite dependencies installed: `./install.sh -t`. It sets `tools.enabled` to true and makes Helm consume additional values from additionalManifests.yaml.

## Manual helm

If you do not want to use helper `./install.sh` (and `./uninstall.sh`) script:

1. Install Operators
```sh
helm install --values values.yaml --values additionalManifests.yaml --wait -g operators/
```
2. Install instances (operands)
```sh
helm install --values values.yaml --values additionalManifests.yaml --wait -g instances/
```

# Troubleshooting

## Cannot re-use name

```
$ ./install.sh 
Installing operators
Error: INSTALLATION FAILED: cannot re-use a name that is still in use
```
To fix this execute `helm uninstall kuadrant-operators`

## Unable to continue with install

```
$ ./install.sh 
Installing operators
Error: INSTALLATION FAILED: Unable to continue with install: CustomResourceDefinition "gatewayclasses.gateway.networking.k8s.io" in namespace "" exists and cannot be imported into the current release: invalid ownership metadata; label validation error: missing key "app.kubernetes.io/managed-by": must be set to "Helm"; annotation validation error: missing key "meta.helm.sh/release-name": must be set to "kuadrant-operators"; annotation validation error: missing key "meta.helm.sh/release-namespace": must be set to "default"
```
This happens if there are some leftovers there on a cluster. Typically the Kuadrant had been installed on the cluster previously not using Helm. To overcome such issues everything that Helm creates needs to be removed prior to installing via Helm. For this particular error the Gateway API CRDs needed to be removed.
