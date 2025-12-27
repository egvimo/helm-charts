#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR
set -x

bash charts/longhorn/ci/prepare.sh

helm dependency update charts/longhorn
helm install longhorn charts/longhorn --namespace longhorn-config-ns --wait
