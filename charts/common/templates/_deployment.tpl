{{- define "common.deployment.tpl" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicaCount }}
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      {{- with .Values.podAnnotations }}
      annotations:
        {{- toYaml . | nindent 8 }}
      {{- end }}
      labels:
        {{- include "common.selectorLabels" . | nindent 8 }}
    spec:
      securityContext:
        {{- toYaml .Values.podSecurityContext | nindent 8 }}
      containers: []
      volumes: []
{{- end -}}
{{- define "common.deployment" -}}
{{- include "common.util.merge" (append . "common.deployment.tpl") -}}
{{- end -}}

{{- define "common.container" -}}
name: {{ .Chart.Name }}
securityContext:
  {{- toYaml .Values.securityContext | nindent 12 }}
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
imagePullPolicy: {{ .Values.image.pullPolicy }}
resources:
  {{- toYaml .Values.resources | nindent 12 }}
{{- end }}
