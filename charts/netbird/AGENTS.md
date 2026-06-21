# AGENTS.md — netbird

> AI-agent context for the netbird Helm chart.

---

## Chart Identity

| Field        | Value                                        |
| ------------ | -------------------------------------------- |
| **Type**     | application                                  |
| **Apps**     | management, signal, relay, dashboard         |
| **Registry** | ghcr.io/fmauneko/helm-charts/charts/netbird  |
| **Notes**    | NetBird mesh VPN — split topology deployment |

---

## Components

The netbird chart deploys the following separate workloads/components:

- **management**: Stateful workload. SQLite (single-writer) requires `replicas: 1` and management strategy MUST be `Recreate` to avoid database locking. Listens on port 33073 (legacy gRPC) and port 80 (HTTP API).
- **signal**: Stateless workload. Netbird signal service listening on port 10000 (gRPC).
- **relay**: Stateless workload. Netbird relay service listening on port 443 (HTTP/WebSocket) for TLS-terminated proxy connections. Optionally exposes an embedded STUN service on port 3478/UDP.
- **dashboard**: Stateless workload. Web user interface listening on port 80 (HTTP).
- **operator** (optional subchart, off by default): Official NetBird Kubernetes Operator (`netbird-operator` 0.7.0, alias `operator`, `condition: operator.enabled`). When enabled, cert-manager MUST be installed in the cluster. Run `helm dependency build charts/netbird` locally before any helm invocation.

---

## Auth Modes

NetBird supports two identity provider configurations:

1. **External OIDC**: Bring-your-own identity provider (e.g., Okta, Auth0, Keycloak). Configured using JSON template keys in `management.json` with external endpoints and client credentials.
2. **Embedded Dex**: Runs an in-process Dex identity provider at `/oauth2/` within the same management container/workload (no separate Dex deployment). Utilizes local storage and requires direct callback configurations mapped to the external dashboard URL.

These modes determine different values structures for key fields in `management.json`, particularly within `IdpManagerConfig`, `PKCEAuthorizationFlow`, and the optional embedded IdP sections.

---

## Verified Upstream Contracts

| Contract Area             | Verification Findings | Detail                                                                                                                                                                                                                      |
| ------------------------- | --------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `{{ .ENV }}` substitution | YES                   | Supported globally by `util.ReadJsonWithEnvSub`. Parses the entire file as a Go `text/template` using `os.Environ()` before JSON unmarshalling. Any configuration field can use `"{{ .ENV_VAR }}"`.                         |
| Datastore DSN             | Supported             | - PostgreSQL env: `NB_STORE_ENGINE_POSTGRES_DSN`<br>- MySQL env: `NB_STORE_ENGINE_MYSQL_DSN`<br>- Falls back to legacy `NETBIRD_STORE_ENGINE_*` equivalents. `StoreConfig.Engine` only sets database engine name.           |
| Dashboard env injection   | RUNTIME               | Mechanism uses `supervisord` executing `/usr/local/init_react_envs.sh` at container start. Dynamically updates `OidcTrustedDomains.js` and other static assets with runtime variables.                                      |
| Relay TLS termination     | Proxy Mode            | Pod accepts plain HTTP/ws from TLS-terminating proxy (no `--tls-cert-file` or `--tls-key-file` needed). Terminate at ingress and set WebSocket upgrade headers (`proxy-read-timeout` / `proxy-send-timeout` set to `3600`). |
| Health endpoints          | GET `/api/instance`   | Management lacks `/api/health` or `/status`. Fallback to unauthenticated `GET /api/instance` (returns `{ "setup_required": bool }`) for Liveness/Readiness probes.                                                          |
| PAT-seed setup            | Exit 0                | POST `/api/setup` returns `412 Precondition Failed` if instance is already set up. A status of `412` is treated as a success case by the pat-seed helper script.                                                            |
| Operator `managementURL`  | `--netbird-management-url` | `operator.managementURL` → `--netbird-management-url=<value>` container arg. Defaults to cloud (`https://api.netbird.io`) — **WRONG for self-hosted**. Always set when `operator.enabled=true`.                      |
| Operator credential       | `netbird-mgmt-api-key`    | Operator reads PAT via `secretKeyRef` (Secret name/key configurable via `operator.netbirdAPI.keyFromSecret`). The chart pre-creates this Secret as a NORMAL resource (no hook) so `helm install --wait` never deadlocks. |
| cert-manager              | REQUIRED                  | Webhook TLS requires cert-manager (`operator.webhook.enableCertManager=true` by default). Disable only with BYO `webhook.tls`.                                                                                             |
| Operator CRD lifecycle    | INSTALL-ONCE              | CRDs in `crds/` are installed once. Helm does NOT upgrade or remove them. Cleanup: `kubectl delete crd -l app.kubernetes.io/name=netbird-operator`.                                                                        |

---

## Multi-image Renovate

The netbird chart deploys multiple images with separate release cycles:

- Upstream `netbird` (for management, signal, relay) is tracked by `appVersion` in `Chart.yaml`.
- The dashboard and patSeed helper images are tracked individually in `values.yaml` using custom-regex comments:

```yaml
dashboard:
  image:
    # renovate: datasource=docker depName=netbirdio/dashboard versioning=docker
    repository: 'netbirdio/dashboard'
    # -- Specific dashboard image tag. MUST NOT fall back to appVersion.
    tag: 'v2.38.1'
```

Renovate uses a custom regex manager configured in `renovate.json` to identify these image comments and pull tag updates directly.

> **The comment placement is load-bearing.** The `renovate.json` custom regex manager matches the `# renovate:` line, then the `repository:` line, then the `tag:` line below it — helm-docs `# --` comments in between are tolerated. The `# renovate:` comment MUST sit directly above `repository:` (not above `tag:`). If the block is reordered or the comment is detached from its `repository:`/`tag:` pair, the regex silently stops matching and the tag is no longer tracked. Keep `versioning=docker` only — do **not** add `extractVersion`: Docker versioning already orders the `v`-prefixed dashboard tags and Renovate writes the full `vX.Y.Z` tag back (verified update path: `v2.38.1` → `v2.39.0`).

---

## Operator Integration

The netbird chart optionally bundles the official netbird-operator as a Helm subchart dependency (`operator.enabled: false` by default, alias `operator`).

**Subchart dependency:**

- `charts/netbird/Chart.lock` is committed. The vendored `.tgz` is git-ignored.
- Always run `helm dependency build charts/netbird` before any local `helm template`, `helm install`, or `ct lint`.
- The `netbird-operator` subchart version in `Chart.yaml` is tracked by Renovate via the custom-regex manager in `renovate.json`.

**PAT auto-wire + rollout-restart (AUTO credential mode, `patSeed.writeOperatorApiKey=true`):**

1. The chart pre-creates the operator API-key Secret as a NORMAL resource (empty placeholder, `helm.sh/resource-policy: keep`).
2. `helm install --wait` completes: operator pod is Ready but idle (credential empty — this is normal).
3. The `pat-seed` post-install Job bootstraps the account, writes the real PAT to `<release>-pat`, patches the operator Secret, and rollout-restarts the operator Deployment.
4. On a **412 (already-initialized)** server in AUTO mode: pat-seed copies from `<release>-pat` if it exists, else exits non-zero. Switch to BYO mode (`patSeed.writeOperatorApiKey=false`) and pre-create the Secret manually.

**Exposing a Service (DNS zone must PRE-EXIST in the NetBird dashboard before any NetworkRouter):**

```yaml
extraManifests:
  - apiVersion: netbird.io/v1alpha1
    kind: NetworkRouter
    metadata:
      name: prod
      namespace: netbird
    spec:
      dnsZoneRef:
        name: prod.company.internal
  - apiVersion: netbird.io/v1alpha1
    kind: NetworkResource
    metadata:
      name: my-svc
      namespace: default
    spec:
      networkRouterRef: { name: prod, namespace: netbird }
      serviceRef: { name: my-svc }
      groups: [{ name: All }]
```

---

## CRITICAL WARNINGS

- **SQLite Database Locks**: `management.replicas` must always be `1` and strategy must be `Recreate`. SQLite does not support concurrent writers.
- **Management Secret Deletion**: If you delete the Kubernetes Secret containing the management state or encryption keys, the data store will become unreadable, resulting in data loss.
- **Relay Exposed Address**: The value `relay.exposedAddress` must represent the actual external URL/port accessible by netbird agents (e.g. `relay.example.com:443`).

---

## Pre-PR Checklist

- [ ] `helm template ./charts/netbird/` renders without errors
- [ ] `helm unittest ./charts/netbird/` — all suites pass
- [ ] `helm template ./charts/netbird/ | kubeconform -strict -summary -` — no errors
- [ ] `helm-docs` re-run produces no diff on `README.md`
- [ ] `values.schema.json` updated if new value keys were added
- [ ] `appVersion` Renovate comment present and correct in `Chart.yaml`
- [ ] Primary images fallback to `""` for `appVersion` while separate release cycle images are explicitly pinned
- [ ] `helm dependency build charts/netbird` succeeds and `Chart.lock` is committed
- [ ] When `operator.*` changes: operator-on render produces a non-hook API-key Secret; guards fire on empty `managementURL`; `helm unittest charts/netbird` passes the operator suites (`operator_test.yaml`, `operator_apikey_test.yaml`)
