#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR

kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/refs/heads/main/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
