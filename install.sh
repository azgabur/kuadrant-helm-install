#!/bin/bash
# Quick script to run Helm

cd "$(dirname "$0")" || exit 1

additional_flags=''

if [[ "$1" == "-t" ]]; then
    additional_flags+=" --values additionalManifests.yaml --set tools.enabled=true"
fi

if [[ "$INSTALL_RHCL_GA" == "true" ]]; then
    additional_flags+=" --set kuadrant.indexImage='' --set kuadrant.operatorName=rhcl-operator --set kuadrant.channel=stable"
fi

echo "---Installing operators---"
helm_cmd="helm install --values values.yaml $additional_flags --wait kuadrant-operators operators/"
eval "$helm_cmd"

echo "--Installing instances---"
helm_cmd="helm install --values values.yaml $additional_flags --wait kuadrant-instances instances/"
eval "$helm_cmd"

echo "Success!"
