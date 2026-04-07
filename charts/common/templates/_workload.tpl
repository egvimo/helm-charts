{{- define "common.workload.tpl" -}}
apiVersion: apps/v1
kind: {{ .Workload.kind }}
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  {{- if hasKey .Values "replicaCount" }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  revisionHistoryLimit: 3
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
  {{- include "common.pod.tpl" . | nindent 2 }}
{{- end }}
