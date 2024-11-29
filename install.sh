#!/bin/bash
# Quick script to run helm

cd "$(dirname "$0")" || exit 1

IMAGE="${IMAGE:-quay.io/kuadrant/kuadrant-operator-catalog:nightly-$(date +%d-%m-%Y)}"  # TODO NOT USED
CHANNEL="${CHANNEL:-stable}"  # TODO TEMP CHANGED TO stable
DEPLOY_TESTSUITE="${DEPLOY_TESTSUITE:-true}"

if [ "$1" = "-t" ]; then
    # echo "Installing channel $CHANNEL with image: $IMAGE"
    echo "Testsuite deploy: $DEPLOY_TESTSUITE"
    echo "---Installing operators---" && \
    helm install \
      --values values.yaml \
      --values additionalManifests.yaml \
      --values extraCatalogSources.yaml \
      --set kuadrant.indexImage="$IMAGE" \
      --set kuadrant.channel="$CHANNEL" \
      --set tools.enabled="$DEPLOY_TESTSUITE" \
      --wait kuadrant-operators operators/ && \
    echo "--Installing instances---" && \
    helm install \
      --values values.yaml \
      --values additionalManifests.yaml \
      --values extraCatalogSources.yaml \
      --set kuadrant.indexImage="$IMAGE" \
      --set kuadrant.channel="$CHANNEL" \
      --set tools.enabled="$DEPLOY_TESTSUITE" \
      --wait \
      kuadrant-instances instances/ && \
    ./hack.sh && \
    echo "Success!"
else
    echo "Using defaults from values.yaml"
    echo "Installing operators" && \
    helm install --values values.yaml --wait kuadrant-operators operators/ && \
    echo "Installing instances" && \
    helm install --values values.yaml --wait kuadrant-instances instances/ && \
    echo "Success!"
fi
