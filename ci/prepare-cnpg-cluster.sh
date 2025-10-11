#!/usr/bin/env bash
set -euo pipefail

bash ci/prepare-cnpg.sh

helm install cnpg charts/cnpg --namespace cnpg-cluster
