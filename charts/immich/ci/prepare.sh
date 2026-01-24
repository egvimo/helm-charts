#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR

source ci/prepare-lib.sh

install_chart cnpg-cluster

kubectl wait --for=condition=Ready cluster/cnpg-cluster --timeout=120s -n "$CT_NAMESPACE"
kubectl wait --for=jsonpath='{.status.applied}'=true database/test --timeout=240s -n "$CT_NAMESPACE"
kubectl exec cnpg-cluster-1 -n "$CT_NAMESPACE" -- psql -d test -tAc "CREATE EXTENSION vchord CASCADE;"
