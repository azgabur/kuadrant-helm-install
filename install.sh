#!/bin/bash
# Quick script to run Helm

cd "$(dirname "$0")" || exit 1

additional_flags=''

if [[ "$1" = "-t" ]]; then
    additional_flags+="--values additionalManifests.yaml --set tools.enabled=true"
fi

echo "---Installing operators---"
helm install --values values.yaml $additional_flags \
  --wait kuadrant-operators operators/

echo "--Installing instances---"
helm install --values values.yaml $additional_flags \
  --wait kuadrant-instances instances/

echo "Success!"
