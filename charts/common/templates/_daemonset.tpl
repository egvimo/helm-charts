{{- define "common.daemonset.tpl" -}}
{{- $workload := dict "kind" "DaemonSet" -}}
{{- $ctx := merge (dict "Workload" $workload) . -}}
{{- include "common.workload.tpl" $ctx }}
{{- end -}}

{{- define "common.daemonset" -}}
{{- include "common.util.merge" (append . "common.daemonset.tpl") -}}
{{- end -}}
