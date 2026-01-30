#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR

source ci/prepare-lib.sh

install_chart cnpg-cluster

kubectl exec cnpg-cluster-1 -n "$CT_NAMESPACE" -- \
  psql -d test -tAc "CREATE EXTENSION vchord CASCADE; CREATE EXTENSION earthdistance CASCADE;"
