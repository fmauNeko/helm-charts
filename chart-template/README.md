# chart-template

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 1.27.0](https://img.shields.io/badge/AppVersion-1.27.0-informational?style=flat-square)

Template for new Helm charts. Copy to charts/<name>/ and customize.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules for pod scheduling |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"nginx"` | Container image repository |
| image.tag | string | `""` | Container image tag. Defaults to chart appVersion when empty. |
| nodeSelector | object | `{}` | Node selector for pod scheduling |
| replicaCount | int | `1` | Number of pod replicas |
| resources | object | `{}` | Resource requests and limits for the container |
| service.port | int | `80` | Service port |
| service.type | string | `"ClusterIP"` | Kubernetes Service type |
| tolerations | list | `[]` | Tolerations for pod scheduling |

