{{- define "dotbot.configData" -}}
{{- range $k, $v := .Values.env }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- end }}

{{- define "dotbot.secretsData" -}}
Discord__PublicKey: {{ .Values.discord.publicKey | b64enc | quote }}
Discord__Token: {{ .Values.discord.token | b64enc | quote }}
{{- range $k, $v := .Values.discord.webhooks }}
Discord__Webhooks__{{ $k }}: {{ $v | b64enc | quote }}
{{- end }}
ConnectionStrings__dotbot: {{ (printf "Host=%s;Port=%d;Username=%s;Password=%s;" (include "dotbot.postgres.fullname" .) (.Values.postgres.service.postgresPort | int) .Values.postgres.username .Values.postgres.password) | b64enc | quote }}
RabbitMQ__Endpoint: {{ (printf "%s.%s.svc.cluster.local" (include "dotbot.rabbitmq.fullname" .) .Release.Namespace ) | b64enc | quote }}
RabbitMQ__Port: {{ (printf "%d" (.Values.rabbitmq.service.amqpPort | int)) | b64enc | quote }}
RabbitMQ__User: {{ .Values.rabbitmq.username | b64enc | quote }}
RabbitMQ__Password: {{ .Values.rabbitmq.password | b64enc | quote }}
AWS_ACCESS_KEY_ID: {{ .Values.s3.accessKeyId | b64enc | quote }}
AWS_SECRET_ACCESS_KEY: {{ .Values.s3.secretAccessKey | b64enc | quote }}
{{- end -}}

{{- define "dotbot.secretsMigratorData" -}}
CONNECTIONSTRING: {{ (printf "Host=%s;Port=%d;Username=%s;Password=%s;" (include "dotbot.postgres.fullname" .) (.Values.postgres.service.postgresPort | int) .Values.postgres.username .Values.postgres.password) | b64enc | quote }}
{{- end -}}
