{{- define "common.servicemonitor" -}}
{{- if  .Values.serviceMonitor.enabled -}}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  {{- with .Values.serviceMonitor.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
  namespaceSelector:
    matchNames:
      - {{ .Release.Namespace }}
  endpoints:
    - port: {{ .Values.service.name | default "http" }}
      {{- with .Values.serviceMonitor.path }}
      path: {{ . }}
      {{- end }}
      {{- with .Values.serviceMonitor.interval }}
      interval: {{ . }}
      {{- end }}
      {{- with .Values.serviceMonitor.scrapeTimeout }}
      scrapeTimeout: {{ . }}
      {{- end }}
      {{- with .Values.serviceMonitor.relabelings }}
      relabelings:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.serviceMonitor.metricRelabelings }}
      metricRelabelings:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      {{- with .Values.serviceMonitor.authorization }}
      authorization:
        {{- toYaml . | nindent 8 }}
      {{- end }}
{{- end }}
{{- end }}
