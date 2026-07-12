# netbird

![Version: 0.3.7](https://img.shields.io/badge/Version-0.3.7-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.74.4](https://img.shields.io/badge/AppVersion-0.74.4-informational?style=flat-square)

Self-hosted NetBird mesh VPN — management, signal, relay, and dashboard.

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| oci://ghcr.io/netbirdio/helm-charts | operator(netbird-operator) | 0.7.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth.embedded.cliRedirectURIs | list | `["http://localhost:53000/","http://localhost:54000/"]` | CLI redirect URIs for embedded Dex |
| auth.embedded.issuer | string | `""` | Embedded Dex issuer URL (defaults to https://<global.host>/oauth2 if empty) |
| auth.embedded.localAuthDisabled | bool | `false` | Disable local username/password authentication (requires external connector) |
| auth.embedded.owner.email | string | `""` | Initial owner email |
| auth.embedded.owner.username | string | `""` | Initial owner username |
| auth.embedded.storage.dsn | string | `""` | Dex postgres DSN (used when storage.type=postgres; referenced via {{ .NB_DEX_STORE_DSN }} placeholder) |
| auth.embedded.storage.type | string | `"sqlite3"` | Dex storage type: sqlite3 or postgres |
| auth.external.audience | string | `""` | OIDC audience |
| auth.external.authKeysLocation | string | `""` | Explicit JWKS URL override. Empty = omit AuthKeysLocation and let NetBird discover jwks_uri from oidcConfigEndpoint. |
| auth.external.authority | string | `""` | OIDC authority/issuer URL |
| auth.external.clientId | string | `""` | OIDC client ID for the dashboard |
| auth.external.deviceAuthFlow.providerConfig.audience | string | `""` | Device auth flow audience |
| auth.external.deviceAuthFlow.providerConfig.clientId | string | `""` | Device auth flow client ID |
| auth.external.deviceAuthFlow.providerConfig.scope | string | `"openid"` | Device auth flow scope |
| auth.external.idpManager.clientConfig.clientId | string | `""` | IdP client ID (M2M) |
| auth.external.idpManager.clientConfig.grantType | string | `"client_credentials"` | Grant type for IdP management |
| auth.external.idpManager.clientConfig.issuer | string | `""` | IdP issuer URL |
| auth.external.idpManager.clientConfig.tokenEndpoint | string | `""` | IdP token endpoint |
| auth.external.idpManager.extraConfig | object | `{}` | The NB_ZITADEL_PAT env var must be present in the management Secret (via secrets.existingSecret or the auto-generated secret). |
| auth.external.idpManager.managerType | string | `"none"` | IdP manager type: none, auth0, azure, keycloak, zitadel, authentik, okta, google, jumpcloud, pocketid, dex |
| auth.external.oidcConfigEndpoint | string | `""` | OIDC discovery endpoint. Empty = <authority>/.well-known/openid-configuration. NetBird uses this to discover issuer, JWKS, token, authorization, and device authorization endpoints. |
| auth.external.pkceAuthFlow.providerConfig.audience | string | `""` | PKCE auth flow audience |
| auth.external.pkceAuthFlow.providerConfig.authorizationEndpoint | string | `""` | PKCE auth flow authorization endpoint |
| auth.external.pkceAuthFlow.providerConfig.clientId | string | `""` | PKCE auth flow client ID |
| auth.external.pkceAuthFlow.providerConfig.redirectURLs | list | `[]` | PKCE redirect URIs |
| auth.external.pkceAuthFlow.providerConfig.scope | string | `"openid"` | PKCE auth flow scope |
| auth.external.pkceAuthFlow.providerConfig.tokenEndpoint | string | `""` | PKCE auth flow token endpoint |
| auth.external.pkceAuthFlow.providerConfig.useIDToken | bool | `false` | Use ID token instead of access token |
| auth.external.redirectUri | string | `"/nb-auth"` | Redirect URI after login. Must be a path only (e.g. /nb-auth) — the dashboard JS prepends window.location.origin automatically. |
| auth.external.silentRedirectUri | string | `"/nb-silent-auth"` | Silent redirect URI for token renewal. Must be a path only (e.g. /nb-silent-auth). |
| auth.external.supportedScopes | string | `"openid profile email offline_access"` | Supported OIDC scopes |
| auth.external.tokenSource | string | `"accessToken"` | Token source: 'accessToken' or 'idToken' |
| auth.external.useAuth0 | bool | `false` | Set to true only for Auth0 |
| auth.mode | string | `"external"` | Auth mode: 'external' (bring-your-own OIDC) or 'embedded' (in-process Dex) |
| dashboard.affinity | object | `{}` | Affinity rules for dashboard pods |
| dashboard.extraEnv | list | `[]` | Additional environment variables for dashboard container |
| dashboard.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| dashboard.image.repository | string | `"netbirdio/dashboard"` | Dashboard image repository |
| dashboard.image.tag | string | `"v2.90.3"` | Dashboard image tag. NOTE: dashboard has its own release track, never falls back to chart appVersion. |
| dashboard.nodeSelector | object | `{}` | Node selector for dashboard pods |
| dashboard.podAnnotations | object | `{}` | Pod annotations for dashboard |
| dashboard.replicaCount | int | `1` | Number of dashboard replicas |
| dashboard.resources | object | `{}` | Resource requests/limits for dashboard |
| dashboard.service.port | int | `80` | Dashboard HTTP port |
| dashboard.service.type | string | `"ClusterIP"` | Dashboard service type |
| dashboard.tolerations | list | `[]` | Tolerations for dashboard pods |
| extraManifests | list | `[]` | Extra Kubernetes manifests to deploy (raw YAML, processed with tpl). Use this to expose in-cluster Services onto your NetBird network when the operator is enabled. Prerequisites: a DNS zone must PRE-EXIST in the NetBird dashboard (e.g. prod.company.internal) before creating a NetworkRouter. Example:    - apiVersion: netbird.io/v1alpha1     kind: NetworkRouter     metadata:       name: prod       namespace: netbird     spec:       dnsZoneRef:         name: prod.company.internal   - apiVersion: netbird.io/v1alpha1     kind: NetworkResource     metadata:       name: my-service       namespace: default     spec:       networkRouterRef:         name: prod         namespace: netbird       serviceRef:         name: my-service       groups:         - name: All |
| gateway.enabled | bool | `false` | Enable Gateway API routes (requires Gateway API CRDs) |
| gateway.parentRef.name | string | `""` | Gateway name to attach routes to |
| gateway.parentRef.namespace | string | `""` | Gateway namespace |
| gateway.parentRef.sectionName | string | `""` | Gateway section name |
| global.dashboard | object | `{"host":""}` | Per-component host overrides for split-host routing (leave empty to use global.host) |
| global.dashboard.host | string | `""` | Dashboard hostname override |
| global.host | string | `""` | Primary hostname for single-host path-based routing (e.g. netbird.example.com) |
| global.imagePullSecrets | list | `[]` | Image pull secrets applied to all pods |
| global.management | object | `{"host":""}` | Per-component host overrides for split-host routing (leave empty to use global.host) |
| global.management.host | string | `""` | Management hostname override (empty = use global.host) |
| global.relay | object | `{"host":""}` | Per-component host overrides for split-host routing (leave empty to use global.host) |
| global.relay.host | string | `""` | Relay hostname override |
| global.signal | object | `{"host":""}` | Per-component host overrides for split-host routing (leave empty to use global.host) |
| global.signal.host | string | `""` | Signal hostname override |
| ingress.annotations | object | `{}` | Additional ingress annotations |
| ingress.className | string | `""` | Ingress class name |
| ingress.enabled | bool | `true` | Enable Ingress resources |
| ingress.tls | list | `[]` | TLS configuration |
| management.affinity | object | `{}` | Affinity rules for management pods |
| management.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| management.image.repository | string | `"netbirdio/management"` | Management image repository |
| management.image.tag | string | `""` | Management image tag. Defaults to chart appVersion when empty. |
| management.logFile | string | `"console"` | Management log destination. 'console' streams to stdout/stderr for kubectl logs; a path writes to a rotated file inside the container. |
| management.logLevel | string | `"info"` | Management log level (panic, fatal, error, warn, info, debug, trace) |
| management.nodeSelector | object | `{}` | Node selector for management pods |
| management.persistence.enabled | bool | `true` | Enable persistent storage for management data directory |
| management.persistence.existingClaim | string | `""` | Use an existing PVC instead of creating one |
| management.persistence.size | string | `"1Gi"` | Storage size for management datadir |
| management.persistence.storageClass | string | `""` | Storage class (empty = cluster default) |
| management.podAnnotations | object | `{}` | Pod annotations for management |
| management.replicaCount | int | `1` | Number of management replicas (always 1 — Recreate strategy required for SQLite) |
| management.resources | object | `{}` | Resource requests/limits for management |
| management.service.grpcPort | int | `33073` | Management gRPC port |
| management.service.httpPort | int | `80` | Management HTTP port |
| management.service.type | string | `"ClusterIP"` | Management service type |
| management.tolerations | list | `[]` | Tolerations for management pods |
| managementConfig.disableDefaultPolicy | bool | `false` | Disable NetBird default allow-all policy |
| managementConfig.relay.addresses | list | `[]` | External relay addresses (if not using this chart's relay) |
| managementConfig.reverseProxy.trustedHTTPProxies | list | `[]` | Trusted HTTP proxy CIDR blocks |
| managementConfig.reverseProxy.trustedPeers | list | `[]` | Trusted peers for reverse proxy |
| managementConfig.signal.proto | string | `"https"` | Signal protocol advertised to peers |
| managementConfig.signal.uri | string | `""` | External signal address advertised to peers (HOST:PORT). Empty = in-cluster <release>-signal:10000 |
| managementConfig.stuns | list | `[]` | STUN servers list. String entries (for example, stun:stun.example.com:3478) are normalized to NetBird Host objects. |
| managementConfig.turn.credentialsTTL | string | `"86400s"` | TURN credential TTL (e.g. '86400s') |
| managementConfig.turn.timeBasedCredentials | bool | `false` | Use time-based credentials for TURN |
| managementConfig.turn.turns | list | `[]` | External TURN servers list. String entries are normalized to NetBird Host objects; object entries may set proto, uri, username, and password. |
| metrics.serviceMonitor.enabled | bool | `false` | Enable Prometheus ServiceMonitor (requires Prometheus Operator) |
| metrics.serviceMonitor.interval | string | `"30s"` | Scrape interval |
| metrics.serviceMonitor.labels | object | `{}` | Additional labels for ServiceMonitor |
| operator.cluster.dns | string | `"svc.cluster.local"` | Cluster DNS suffix (used for webhook cert SANs and DNS resource names) |
| operator.cluster.name | string | `"kubernetes"` | Cluster name used for generating NetBird resource names |
| operator.enabled | bool | `false` | Enable the optional NetBird Kubernetes Operator subchart (requires cert-manager in the cluster) |
| operator.gatewayAPI.enabled | bool | `false` | Enable Gateway API integration (requires Gateway API CRDs) |
| operator.managementURL | string | `""` | Management API URL of your self-hosted NetBird server. REQUIRED when operator.enabled=true. Typically https://<global.host> (external) or http://<release>-netbird-management:80 (in-cluster). Defaults to NetBird Cloud (https://api.netbird.io) if not set — which is WRONG for self-hosted. |
| operator.netbirdAPI.keyFromSecret.key | string | `"NB_API_KEY"` | Key within the Secret that holds the API token |
| operator.netbirdAPI.keyFromSecret.name | string | `"netbird-mgmt-api-key"` | Name of the Secret containing the NetBird management API key |
| operator.webhook.enableCertManager | bool | `true` | Use cert-manager to provision webhook certificates (recommended). cert-manager must be installed in the cluster. |
| patSeed.activeDeadlineSeconds | int | `300` | Maximum time in seconds before the Job is terminated |
| patSeed.adminEmail | string | `""` | Initial owner email |
| patSeed.adminPassword | string | `""` | Initial owner password used for POST /api/setup. Prefer setting through an external values file or secret management workflow. |
| patSeed.enabled | bool | `false` | Enable the PAT seed bootstrap Job (creates initial account + PAT via native /api/setup endpoint) |
| patSeed.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| patSeed.image.repository | string | `"curlimages/curl"` | Image for the PAT seed job (needs curl + sh) |
| patSeed.image.tag | string | `"8.21.0"` | PAT seed job image tag |
| patSeed.seedDefaultResources | bool | `true` | Seed the default All group and allow-all policy |
| patSeed.writeOperatorApiKey | bool | `true` | When true (default), the pat-seed Job also writes the NetBird PAT into the operator's API-key Secret (netbird-mgmt-api-key) so the operator can connect to the management API. Set to false to manage the operator credential yourself (BYO mode). |
| relay.affinity | object | `{}` | Affinity rules for relay pods |
| relay.exposedAddress | string | `"relay.example.com:443"` | REQUIRED: Externally reachable relay address (e.g. relay.example.com:443). Must be set for peers to connect. |
| relay.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| relay.image.repository | string | `"netbirdio/relay"` | Relay image repository |
| relay.image.tag | string | `""` | Relay image tag. Defaults to chart appVersion when empty. |
| relay.logLevel | string | `"info"` | Relay log level |
| relay.nodeSelector | object | `{}` | Node selector for relay pods |
| relay.podAnnotations | object | `{}` | Pod annotations for relay |
| relay.replicaCount | int | `1` | Number of relay replicas |
| relay.resources | object | `{}` | Resource requests/limits for relay |
| relay.service.port | int | `443` | Relay HTTP/WebSocket port |
| relay.service.type | string | `"ClusterIP"` | Relay service type |
| relay.stun.enabled | bool | `true` | Enable embedded STUN server in relay |
| relay.stun.service.port | int | `3478` | STUN port |
| relay.stun.service.type | string | `"LoadBalancer"` | STUN UDP Service type (LoadBalancer or NodePort) |
| relay.tolerations | list | `[]` | Tolerations for relay pods |
| secrets.existingSecret | string | `""` | Use an existing Secret instead of creating one. Secret must contain all required env vars. |
| serviceAccount.annotations | object | `{}` | Annotations to add to service accounts |
| serviceAccount.create | bool | `true` | Create a ServiceAccount for each component |
| signal.affinity | object | `{}` | Affinity rules for signal pods |
| signal.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| signal.image.repository | string | `"netbirdio/signal"` | Signal image repository |
| signal.image.tag | string | `""` | Signal image tag. Defaults to chart appVersion when empty. |
| signal.nodeSelector | object | `{}` | Node selector for signal pods |
| signal.podAnnotations | object | `{}` | Pod annotations for signal |
| signal.replicaCount | int | `1` | Number of signal replicas |
| signal.resources | object | `{}` | Resource requests/limits for signal |
| signal.service.httpPort | int | `80` | Signal HTTP/WebSocket-proxy port (serves /ws-proxy/signal — the primary client transport in NetBird v0.65+) |
| signal.service.port | int | `10000` | Signal gRPC port (backward-compatibility transport for legacy agents) |
| signal.service.type | string | `"ClusterIP"` | Signal service type |
| signal.tolerations | list | `[]` | Tolerations for signal pods |
| store.engine | string | `"sqlite"` | Storage engine: sqlite (default), postgres, or mysql |
| store.mysql.dsn | string | `""` | MySQL DSN for main datastore (injected as NB_STORE_ENGINE_MYSQL_DSN env var) |
| store.postgres.dsn | string | `""` | PostgreSQL DSN for main datastore (injected as NB_STORE_ENGINE_POSTGRES_DSN env var) |

