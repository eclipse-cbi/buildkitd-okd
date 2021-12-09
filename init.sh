#!/usr/bin/env bash

# Bash strict-mode
set -o errexit
set -o nounset
set -o pipefail

IFS=$'\n\t'

SCRIPT_FOLDER="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

kubectl create namespace foundation-internal-infra-buildkitd
kubectl patch namespace foundation-internal-infra-buildkitd --type merge --patch '{"metadata":{"annotations":{"openshift.io/sa.scc.supplemental-groups":"1000/1", "openshift.io/sa.scc.uid-range": "1000/1"}}}'

jsonnet "${SCRIPT_FOLDER}/rootless-scc.jsonnet" | oc apply -f -
oc adm policy add-scc-to-user rootless -z default -n foundation-internal-infra-buildkitd

jsonnet "${SCRIPT_FOLDER}/deployment.jsonnet" | oc apply -f -
