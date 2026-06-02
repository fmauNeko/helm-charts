{{/* Expand the name of the chart */}}
{{- define "netbird.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Create a default fully qualified app name */}}
{{- define "netbird.fullname" -}}
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

{{/* Chart label */}}
{{- define "netbird.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Common labels */}}
{{- define "netbird.labels" -}}
helm.sh/chart: {{ include "netbird.chart" . }}
{{ include "netbird.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Selector labels */}}
{{- define "netbird.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Per-component fullname helpers — REQUIRED by all workload templates */}}
{{- define "netbird.management.fullname" -}}
{{- printf "%s-management" (include "netbird.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "netbird.signal.fullname" -}}
{{- printf "%s-signal" (include "netbird.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "netbird.relay.fullname" -}}
{{- printf "%s-relay" (include "netbird.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "netbird.dashboard.fullname" -}}
{{- printf "%s-dashboard" (include "netbird.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Per-component selector labels (include component label) */}}
{{- define "netbird.management.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: management
{{- end }}

{{- define "netbird.signal.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: signal
{{- end }}

{{- define "netbird.relay.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: relay
{{- end }}

{{- define "netbird.dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "netbird.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: dashboard
{{- end }}

{{/* Per-component service account name helpers */}}
{{- define "netbird.management.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- include "netbird.management.fullname" . }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "netbird.signal.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- include "netbird.signal.fullname" . }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "netbird.relay.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- include "netbird.relay.fullname" . }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "netbird.dashboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- include "netbird.dashboard.fullname" . }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Per-component image helpers */}}
{{/* management/signal/relay fall back to .Chart.AppVersion */}}
{{- define "netbird.management.image" -}}
{{- $tag := default .Chart.AppVersion .Values.management.image.tag -}}
{{- printf "%s:%s" .Values.management.image.repository $tag -}}
{{- end }}

{{- define "netbird.signal.image" -}}
{{- $tag := default .Chart.AppVersion .Values.signal.image.tag -}}
{{- printf "%s:%s" .Values.signal.image.repository $tag -}}
{{- end }}

{{- define "netbird.relay.image" -}}
{{- $tag := default .Chart.AppVersion .Values.relay.image.tag -}}
{{- printf "%s:%s" .Values.relay.image.repository $tag -}}
{{- end }}

{{/* dashboard MUST NOT fall back to appVersion — has its own release track */}}
{{- define "netbird.dashboard.image" -}}
{{- if not .Values.dashboard.image.tag -}}
{{- fail "dashboard.image.tag must be set explicitly — it does not fall back to chart appVersion" -}}
{{- end -}}
{{- printf "%s:%s" .Values.dashboard.image.repository .Values.dashboard.image.tag -}}
{{- end }}

{{/*
Management secret name — uses existingSecret when set, otherwise chart-generated name.
*/}}
{{- define "netbird.management.secretName" -}}
{{- default (include "netbird.management.fullname" .) .Values.secrets.existingSecret -}}
{{- end }}
