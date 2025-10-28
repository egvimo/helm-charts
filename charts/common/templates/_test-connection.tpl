{{- define "common.test-connection" -}}
{{- $args := .Args | default dict -}}
{{- $path := $args.path | default "" -}}
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "common.fullname" . }}-test-connection"
  labels:
    {{- include "common.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['{{ include "common.fullname" . }}:{{ .Values.service.port }}{{ $path }}']
  restartPolicy: Never
{{- end }}
