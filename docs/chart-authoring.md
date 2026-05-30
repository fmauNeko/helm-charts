# Chart Authoring Standard

This document details the standards and conventions for authoring Helm charts in this repository.

## 1. Required Files per Chart

Each chart must include these files and directories:

| File                     | Required    | Generated?           | Description                                    |
| ------------------------ | ----------- | -------------------- | ---------------------------------------------- |
| `Chart.yaml`             | ✅          | No                   | Chart metadata and Renovate appVersion comment |
| `values.yaml`            | ✅          | No                   | Default values, annotated with `# --`          |
| `values.schema.json`     | ✅          | ✅ via `helm schema` | JSON Schema for values validation              |
| `README.md`              | ✅          | ✅ via `helm-docs`   | Auto-generated from values.yaml annotations    |
| `AGENTS.md`              | ✅          | No                   | Per-chart agent guidance (copy from template)  |
| `templates/`             | ✅          | No                   | Kubernetes manifests                           |
| `tests/`                 | Recommended | No                   | helm-unittest test suites                      |
| `ci/install-values.yaml` | Optional    | No                   | Values for full `ct install` gated testing     |
| `CHANGELOG.md`           | ✅          | ✅ by Release Please | Auto-generated, never hand-edit                |

## 2. Chart.yaml Conventions

Your `Chart.yaml` must follow this structure:

```yaml
apiVersion: v2
name: <chart-name>
description: <one-line description>
type: application
version: 0.1.0 # managed by Release Please, never edit manually
# renovate: datasource=docker depName=<upstream-image> versioning=docker
appVersion: '<x.y.z>' # managed by Renovate, never edit manually
```

For multi-image charts, add per-value `# renovate:` comments in `values.yaml` instead. This requires enabling the `helm-values` manager, which is disabled by default, document this as an exception.

## 3. values.yaml Conventions

- The first line must be: `# yaml-language-server: $schema=./values.schema.json` to provide IDE schema support.
- All values must be annotated with `# -- <description>` above the key for helm-docs.
- The `image.tag` value must defaults to `""`. Templates fall back to `.Chart.AppVersion` when empty.

Example:

```yaml
# yaml-language-server: $schema=./values.schema.json

# -- Number of pod replicas
replicaCount: 1

image:
  # -- Container image repository
  repository: nginx
  # -- Container image tag. Defaults to chart appVersion when empty.
  tag: ''
```

## 4. Generated Files

README and schema files are generated automatically. Run these commands after making any changes to `values.yaml`:

```bash
helm-docs --chart-search-root charts/<name>
helm schema -f charts/<name>/values.yaml --use-helm-docs
```

CI enforces that these files do not drift. If committed files differ from generated files, the `fixture` job fails.

## 5. Image Tag to appVersion Fallback

Define an image helper in `_helpers.tpl` as follows:

```tpl
{{- define "<chart>.image" -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end }}
```

Always use `{{ include "<chart>.image" . }}` in Deployment templates. Never hardcode a version.

## 6. Release Please Registration

Register the package in `release-please-config.json` before making your first `feat:` commit.

In `release-please-config.json` packages:

```json
"charts/<name>": {
  "release-type": "helm",
  "component": "<name>",
  "package-name": "<name>"
}
```

In `.release-please-manifest.json`:

```json
"charts/<name>": "0.1.0"
```

Do this in a separate commit BEFORE the `feat(<name>): add initial chart` commit. Release Please needs the manifest entry to bootstrap correctly.

## 7. Pre-PR Checklist

Before opening a pull request, verify the following:

- [ ] `helm lint --strict charts/<name>/` passes
- [ ] `helm template charts/<name>/` renders without errors
- [ ] `helm unittest charts/<name>/` passes (if `tests/` exists)
- [ ] `helm-docs` regenerated with no README diff
- [ ] `helm schema` regenerated with no `values.schema.json` diff
- [ ] `kubeconform` passes on rendered manifests
- [ ] `AGENTS.md` updated if values or behavior changed
- [ ] Commit message follows Conventional Commits format
