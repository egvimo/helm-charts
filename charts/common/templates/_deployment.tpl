{{- define "common.deployment.tpl" -}}
{{- $workload := dict "kind" "Deployment" -}}
{{- $ctx := merge (dict "Workload" $workload) . -}}
{{- include "common.workload.tpl" $ctx }}
{{- end -}}

{{- define "common.deployment" -}}
{{- include "common.util.merge" (append . "common.deployment.tpl") -}}
{{- end -}}
