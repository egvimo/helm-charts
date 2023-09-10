{{- define "common.container" -}}
name: {{ .Chart.Name }}
securityContext:
  {{- toYaml .Values.securityContext | nindent 12 }}
image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
imagePullPolicy: {{ .Values.image.pullPolicy }}
resources:
  {{- toYaml .Values.resources | nindent 12 }}
{{- end }}
