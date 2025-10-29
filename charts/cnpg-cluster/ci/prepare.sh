#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR
set -x

bash charts/cnpg/ci/prepare.sh

helm dependency update charts/cnpg
helm install cnpg charts/cnpg --namespace cnpg-cluster-ns --wait
