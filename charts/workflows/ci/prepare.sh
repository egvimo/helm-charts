#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Error: Command \"${BASH_COMMAND}\" failed at line $LINENO"' ERR

source ci/prepare-lib.sh

install_chart argo-workflows
