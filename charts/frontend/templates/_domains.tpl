

{{- define "frontend.domain" -}}
{{- $projectName := regexReplaceAll "[^[:alnum:]]" (.Values.projectName | default .Release.Namespace) "-"  | trimSuffix "-" | lower }}
{{- $projectNameHash := sha256sum $projectName | trunc 3 }}
{{- $projectName := (ge (len $projectName) 30) | ternary (print ($projectName | trunc 27) $projectNameHash ) $projectName}}

{{- $environmentName := regexReplaceAll "[^[:alnum:]]" (.Values.environmentName | default .Release.Name) "-" | trimSuffix "-" | lower }}
{{- $environmentNameHash := sha256sum $environmentName | trunc 3 }}
{{- $maxEnvironmentNameLength := int (sub 62 (add (len .Values.clusterDomain) (len $projectName))) }}
{{- $environmentName := (ge (len $environmentName) $maxEnvironmentNameLength) | ternary (print ($environmentName | trunc (int (sub $maxEnvironmentNameLength 3))) $environmentNameHash) $environmentName -}}

{{ $environmentName }}.{{ $projectName }}.{{ .Values.clusterDomain }}
{{- end -}}

{{- define "frontend.referenceEnvironment" -}}
{{ regexReplaceAll "[^[:alnum:]]" .Values.referenceData.referenceEnvironment "-" | lower | trunc 50 | trimSuffix "-" }}
{{- end -}}

{{- define "frontend.environment.hostname" -}}
{{ regexReplaceAll "[^[:alnum:]]" (.Values.environmentName | default .Release.Name) "-" | lower | trunc 50 | trimSuffix "-" }}
{{- end -}}

# SSH-related hosts
{{- define "frontend.jumphost" -}}
www-admin@ssh.{{ .Values.clusterDomain }}
{{- end -}}

{{- define "frontend.shellHost" -}}
www-admin@{{ template "frontend.environment.hostname" . }}-shell.{{ .Release.Namespace }}
{{- end -}}
