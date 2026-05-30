# AGENTS.md — `<CHART_NAME>`

> AI-agent context for the `<CHART_NAME>` Helm chart.
> Replace all `<CHART_NAME>` and `<APP_NAME>` placeholders before use.

---

## Chart Identity

| Field        | Value                                      |
| ------------ | ------------------------------------------ |
| **Type**     | application                                |
| **Apps**     | `<APP_NAME>`                               |
| **Registry** | `<REGISTRY>` (e.g. `docker.io`, `ghcr.io`) |
| **Notes**    | `<Any special deployment notes>`           |

---

## Values Structure

Key values in `values.yaml`:

```yaml
replicaCount: 1

image:
  repository: <REGISTRY>/<APP_NAME>
  tag: '' # empty → uses Chart.AppVersion at render time
  pullPolicy: IfNotPresent

service:
  type: ClusterIP
  port: 80

resources: {}
nodeSelector: {}
tolerations: []
affinity: {}
```

---

## Key Value Paths

| Path               | Type   | Default        | Purpose                                   |
| ------------------ | ------ | -------------- | ----------------------------------------- |
| `replicaCount`     | int    | `1`            | Number of pod replicas                    |
| `image.repository` | string | `<APP_NAME>`   | Container image repository                |
| `image.tag`        | string | `""`           | Image tag; empty = use `Chart.AppVersion` |
| `image.pullPolicy` | string | `IfNotPresent` | Kubernetes image pull policy              |
| `service.type`     | string | `ClusterIP`    | Kubernetes Service type                   |
| `service.port`     | int    | `80`           | Service port                              |
| `resources`        | object | `{}`           | CPU/memory requests and limits            |
| `nodeSelector`     | object | `{}`           | Node selector constraints                 |
| `tolerations`      | list   | `[]`           | Pod tolerations                           |
| `affinity`         | object | `{}`           | Pod affinity/anti-affinity rules          |

---

## Quick Start

Minimal `ci/install-values.yaml`:

```yaml
replicaCount: 1
image:
  repository: <REGISTRY>/<APP_NAME>
  tag: '' # uses appVersion from Chart.yaml
service:
  port: 80
```

Install command:

```bash
helm upgrade --install <CHART_NAME> ./charts/<CHART_NAME>/ \
  -f ci/install-values.yaml \
  --namespace <NAMESPACE> \
  --create-namespace
```

---

## Template Files

| File                         | Purpose                                                |
| ---------------------------- | ------------------------------------------------------ |
| `templates/_helpers.tpl`     | Named template helpers (name, fullname, labels, image) |
| `templates/deployment.yaml`  | Core workload — one Deployment                         |
| `tests/deployment_test.yaml` | helm-unittest suite validating image resolution        |

---

## appVersion Maintenance

`Chart.yaml` carries a Renovate comment that triggers automatic version bumps:

```yaml
# renovate: datasource=docker depName=<APP_NAME> versioning=docker
appVersion: '<CURRENT_VERSION>'
```

When Renovate detects a new upstream image tag it opens a PR that updates
`appVersion` in place. The `image.tag: ""` default in `values.yaml` ensures
every render automatically picks up the new version without any manual edits.

**Do not pin `image.tag` in production values unless you need to hold back a
specific version.**

---

## Schema Validation

`values.yaml` carries a language-server hint on line 1:

```yaml
# yaml-language-server: $schema=./values.schema.json
```

This enables in-editor validation in VS Code (YAML extension) and JetBrains IDEs.

### Drift check

After editing `values.yaml`, verify the schema is still aligned:

```bash
# Install validator once
go install github.com/yannh/kubeconform/cmd/kubeconform@latest

# Validate rendered manifests
helm template ./charts/<CHART_NAME>/ | kubeconform -strict -summary -
```

If you add new values keys, update `values.schema.json` to match.

---

## CI/CD Integration

### Release Please

The repository uses [Release Please](https://github.com/googleapis/release-please)
to manage chart versioning. When a PR is merged to `main`:

1. Release Please opens a release PR bumping `version` in `Chart.yaml`.
2. On merge of that release PR, a GitHub Release is created and the chart is
   packaged and published.

**Do not manually edit `version` in `Chart.yaml`** — Release Please owns it.

### Gated CI tests

Add `ci/install-values.yaml` to the chart directory to enable full install
tests in CI (e.g. via `ct install`):

```yaml
# ci/install-values.yaml — values used only in CI pipelines
replicaCount: 1
image:
  repository: <REGISTRY>/<APP_NAME>
  tag: ''
```

The chart-testing (`ct`) tool picks up files matching `ci/*.yaml` automatically.

---

## Pre-PR Checklist

- [ ] `helm template ./charts/<CHART_NAME>/` renders without errors
- [ ] `helm unittest ./charts/<CHART_NAME>/` — all suites pass
- [ ] `helm template ... | kubeconform -strict -summary -` — no errors
- [ ] `helm-docs` re-run produces **no diff** on `README.md`
- [ ] `values.schema.json` updated if new value keys were added
- [ ] `appVersion` Renovate comment present and correct in `Chart.yaml`
- [ ] No hard-coded image tags in `values.yaml` (use `""` for appVersion fallback)
