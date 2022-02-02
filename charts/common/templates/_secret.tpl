{{- define "common.secret.tpl" -}}
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
type: Opaque
data: {}
{{- end -}}
{{- define "common.secret" -}}
{{- include "common.util.merge" (append . "common.secret.tpl") -}}
{{- end -}}
