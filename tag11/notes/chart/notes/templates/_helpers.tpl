{{/* chart/notes/templates/_helpers.tpl – Stand Ende Tag 10 */}}

{{/* Labels für Komponente: include "notes.labels" (dict "ctx" $ "name" "api") */}}
{{- define "notes.labels" -}}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/part-of: notes
app.kubernetes.io/instance: {{ .ctx.Release.Name }}
app.kubernetes.io/version: {{ .ctx.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .ctx.Release.Service }}
helm.sh/chart: {{ printf "%s-%s" .ctx.Chart.Name .ctx.Chart.Version }}
{{- end }}

{{- define "notes.selector" -}}
app.kubernetes.io/name: {{ . }}
{{- end }}

{{/* Image: include "notes.image" (dict "ctx" $ "image" .Values.api.image) */}}
{{- define "notes.image" -}}
{{ .image.repository }}:{{ .image.tag | default .ctx.Chart.AppVersion }}
{{- end }}

{{/* Pod-securityContext (restricted); optional mit fester UID */}}
{{- define "notes.podSecurity" -}}
serviceAccountName: notes
securityContext:
  runAsNonRoot: true
  {{- with .uid }}
  runAsUser: {{ . }}
  runAsGroup: {{ . }}
  {{- end }}
  {{- with .fsGroup }}
  fsGroup: {{ . }}
  {{- end }}
  seccompProfile:
    type: RuntimeDefault
{{- end }}

{{- define "notes.containerSecurity" -}}
securityContext:
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop: [ALL]
{{- end }}

{{/* Secrets als Dateien unter /etc/notes */}}
{{- define "notes.secretVolume" -}}
- name: secrets
  projected:
    sources:
      - secret:
          name: {{ .Values.existingSecrets.api }}
          items:
            - key: api-key
              path: api-key
      - secret:
          name: {{ .Values.existingSecrets.db }}
          items:
            - key: db-url
              path: db-url
{{- end }}
