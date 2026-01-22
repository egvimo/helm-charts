#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR

source ci/prepare-lib.sh

install_chart cnpg

kubectl create secret generic test \
  --type=kubernetes.io/basic-auth \
  --from-literal=username=test \
  --from-literal=password=test \
  --namespace $CT_NAMESPACE
