#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR
set -x

helm dependency update charts/argo-workflows
helm install argo-workflows charts/argo-workflows --namespace workflows-ns --wait
