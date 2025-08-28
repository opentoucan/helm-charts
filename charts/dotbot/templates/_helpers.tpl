{{/*
Expand the name of the chart.
*/}}
{{- define "dotbot.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dotbot.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dotbot.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dotbot.labels" -}}
helm.sh/chart: {{ include "dotbot.chart" .context }}
{{ include "dotbot.selectorLabels" (dict "context" .context "component" .component "name" .name) }}
app.kubernetes.io/managed-by: {{ .context.Release.Service }}
app.kubernetes.io/part-of: dotbot
app.kubernetes.io/version: {{ .context.Chart.AppVersion | quote }}
{{- with .context.Values.global.additionalLabels }}
{{ toYaml . }}
{{- end }}
{{- end }}

{{/*
Helm pre-hook annotations for migration
*/}}
{{- define "migrator.annotations" -}}
helm.sh/hook-weight: '5'
helm.sh/hook: pre-install,pre-upgrade
helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
{{- end }}

{{/*
Helm pre-hook annotations for postgres
*/}}
{{- define "postgres.annotations" -}}
helm.sh/hook-weight: '-5'
helm.sh/hook: pre-install,pre-upgrade
helm.sh/hook-delete-policy: before-hook-creation,hook-succeeded
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dotbot.selectorLabels" -}}
{{- if .name -}}
app.kubernetes.io/name: {{ include "dotbot.name" .context }}-{{ .name }}
{{ end -}}
app.kubernetes.io/instance: {{ .context.Release.Name }}
{{- if .component }}
app.kubernetes.io/component: {{ .component }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dotbot.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dotbot.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "dotbot.api.fullname" -}}
{{- printf "%s-%s" (include "dotbot.fullname" .) "api" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dotbot.migrator.fullname" -}}
{{- printf "%s-%s" (include "dotbot.fullname" .) "migrator" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dotbot.postgres.fullname" -}}
{{- printf "%s-%s" (include "dotbot.fullname" .) "postgres" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dotbot.rabbitmq.fullname" -}}
{{- printf "%s-%s" (include "dotbot.fullname" .) "rabbitmq" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "dotbot.s3.fullname" -}}
{{- printf "%s-%s" (include "dotbot.fullname" .) "s3" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
