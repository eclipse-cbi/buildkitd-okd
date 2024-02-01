#!/usr/bin/env bash

# Bash strict-mode
set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

SCRIPT_FOLDER="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

DEPLOYMENT_JSONNET="${SCRIPT_FOLDER}/buildkitd-rootless.jsonnet"
SCC_JSONNET="${SCRIPT_FOLDER}/rootless-scc.jsonnet"

NS="$(jsonnet "${DEPLOYMENT_JSONNET}" | jq -r '.[0].metadata.namespace')"
SA="$(jsonnet "${DEPLOYMENT_JSONNET}" | jq -r '.[0].spec.template.spec.serviceAccountName')"
SCC="$(jsonnet "${SCC_JSONNET}" | jq -r '.metadata.name')"

if ! kubectl get namespace "${NS}" &> /dev/null; then
  kubectl create namespace "${NS}"
fi
kubectl patch namespace "${NS}" --type merge --patch '{"metadata":{"annotations":{"openshift.io/sa.scc.supplemental-groups":"1000/1", "openshift.io/sa.scc.uid-range": "1000/1"}}}'

if ! kubectl get serviceaccount "${SA}" -n "${NS}" &> /dev/null; then
  kubectl create serviceaccount "${SA}" -n "${NS}"
fi

jsonnet "${SCC_JSONNET}" | oc apply -f -
oc adm policy add-scc-to-user "${SCC}" -z "${SA}" -n "${NS}"

jsonnet "${DEPLOYMENT_JSONNET}" | yq eval -P '.[] | splitDoc' - | oc apply -f -
