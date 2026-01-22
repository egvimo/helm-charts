#!/usr/bin/env bash

# Prevent double-sourcing side effects
[[ -n "${PREPARE_LIB_LOADED:-}" ]] && return
PREPARE_LIB_LOADED=1

install_chart() {
  local chart_name="${1:?chart name required}"
  local namespace="${CT_NAMESPACE}"
  local chart_path="charts/${chart_name}"
  local values_file="${chart_path}/ci/default-values.yaml"

  if [[ ! -d "$chart_path" ]]; then
    echo "❌ Chart not found: $chart_path"
    return 1
  fi

  if [[ -f "${chart_path}/ci/prepare.sh" ]]; then
    echo "🛠️ Prepare ${chart_name}"
    bash "${chart_path}/ci/prepare.sh"
  fi

  echo "📦 Install ${chart_name}"
  helm dependency update "$chart_path"

  local helm_args=()
  if [[ -f "$values_file" ]]; then
    helm_args+=(-f "$values_file")
  fi

  helm install "$chart_name" "$chart_path" --namespace "$namespace" --wait "${helm_args[@]}"
}
