#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR

source ci/prepare-lib.sh

install_chart cnpg-cluster

kubectl create secret generic vaultwarden \
	--from-literal=adminToken=test \
	--from-literal=databaseUrl=postgres://test:test@cnpg-cluster-rw/test \
	--namespace "$CT_NAMESPACE"
