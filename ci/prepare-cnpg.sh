#!/usr/bin/env bash
set -euo pipefail

helm repo add cnpg https://cloudnative-pg.github.io/charts/
kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/refs/heads/main/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
