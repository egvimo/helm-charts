{{- define "common.pod.tpl" -}}
template:
  metadata:
    {{- with .Values.podAnnotations }}
    annotations:
      {{- toYaml . | nindent 8 }}
    {{- end }}
    labels:
      {{- include "common.selectorLabels" . | nindent 8 }}
  spec:
    automountServiceAccountToken: false
    securityContext:
      {{- toYaml .Values.podSecurityContext | nindent 8 }}
    containers: []
    volumes: []
    {{- with .Values.nodeSelector }}
    nodeSelector:
      {{- toYaml . | nindent 8 }}
    {{- end }}
    {{- with .Values.affinity }}
    affinity:
      {{- toYaml . | nindent 8 }}
    {{- end }}
    {{- with .Values.tolerations }}
    tolerations:
      {{- toYaml . | nindent 8 }}
    {{- end }}
{{- end }}
