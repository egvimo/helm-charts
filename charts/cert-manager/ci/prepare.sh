#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR

CERT_MANAGER_VERSION=$(yq '.dependencies[] | select(.name == "cert-manager") | .version' charts/cert-manager/Chart.yaml)

kubectl apply -f "https://github.com/cert-manager/cert-manager/releases/download/$CERT_MANAGER_VERSION/cert-manager.crds.yaml"

helm repo add cert-manager https://charts.jetstack.io --force-update
helm upgrade --install cert-manager cert-manager/cert-manager \
  --namespace "$CT_NAMESPACE" \
  --version "$CERT_MANAGER_VERSION" \
  --set installCRDs=false \
  --wait \
  --timeout 5m
kubectl rollout status deployment/cert-manager-webhook \
  --namespace "$CT_NAMESPACE" \
  --timeout=5m

# TODO Use latest version
kubectl apply -f https://raw.githubusercontent.com/traefik/traefik/v3.6/docs/content/reference/dynamic-configuration/kubernetes-crd-definition-v1.yml
