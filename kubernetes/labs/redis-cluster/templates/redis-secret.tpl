{{- $secretName := "redis-secret" -}}
{{- $existing := (lookup "v1" "Secret" .Release.Namespace $secretName) -}}
{{- if $existing }}
# Reuse existing secret if it already exists
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secretName }}
type: Opaque
data:
  password: {{ index $existing.data "password" }}
{{- else }}
# Generate a new password if secret does not exist
apiVersion: v1
kind: Secret
metadata:
  name: {{ $secretName }}
type: Opaque
data:
  password: {{ randAlphaNum 16 | b64enc | quote }}
{{- end }}

# vim: set ft=gotmpl:
