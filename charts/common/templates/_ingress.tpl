{{- define "common.ingress" -}}
{{- if .Values.ingress.enabled -}}
{{- $fullName := include "common.fullname" . -}}
{{- $svcPort := .Values.service.port -}}

{{- $hosts := .Values.ingress.hosts }}

{{- if .Values.ingress.host }}
{{- $hosts = list (dict "host" .Values.ingress.host "paths" (list (dict "path" "/" "pathType" "Prefix"))) }}
{{- end }}

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ $fullName }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  {{- with .Values.ingress.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  {{- if .Values.ingress.ingressClassName }}
  ingressClassName: {{ .Values.ingress.ingressClassName }}
  {{- end }}
  rules:
    {{- range $hosts }}
    - host: {{ .host | quote }}
      http:
        paths:
          {{- range .paths }}
          - path: {{ .path }}
            pathType: {{ .pathType }}
            backend:
              service:
                name: {{ $fullName }}
                port:
                  number: {{ $svcPort }}
          {{- end }}
    {{- end }}
{{- end }}
{{- end }}
