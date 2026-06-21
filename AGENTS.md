# AGENTS

## Project Snapshot

| Aspect    | Details                                                       |
| --------- | ------------------------------------------------------------- |
| Type      | Helm chart library                                            |
| Structure | `charts/<name>/`                                              |
| Registry  | `oci://ghcr.io/fmauneko/helm-charts/charts/<chart>:<version>` |
| Toolchain | pnpm + husky + commitlint + prettier                          |
| CI        | chart-testing + helm-unittest + kubeconform                   |
| Release   | Release Please → OCI                                          |
| Renovate  | maintains appVersion via Chart.yaml comment                   |

Each chart maintains its own AGENTS.md with chart-specific guidance. Always use the nearest one.

## Quick Reference

```bash
# Setup
pnpm install

# Guided commit message authoring
pnpm run commit

# Build chart dependencies (required before helm for charts with subcharts, e.g. netbird/netbird-operator)
helm dependency build charts/<name>/

# Lint and template validation
helm lint --strict charts/<name>/
helm template charts/<name>/
ct lint --config ct.yaml

# Run unit tests
helm unittest charts/<name>/

# Generate documentation and schemas
helm-docs --chart-search-root charts/<name>
helm schema -f charts/<name>/values.yaml --use-helm-docs
```

## Universal Conventions

- Commit messages must follow the Conventional Commits format, using `pnpm run commit` for guided authoring.
- Keep LF line endings via `.gitattributes`. Windows users should use Git Bash or WSL for husky hooks.
- All files must pass prettier formatting: `pnpm exec prettier --check .`
- No secrets are allowed in the repository.

## Branching & PR Workflow

| Branch      | Purpose                                              | Merges To |
| ----------- | ---------------------------------------------------- | --------- |
| `main`      | Production branch (Renovate + Release Please target) | -         |
| `feature/*` | New features or charts                               | `main`    |
| `fix/*`     | Bug fixes                                            | `main`    |

All non-trivial changes must be made via a PR. PRs are auto-labeled by type.

## Version Ownership

| Property       | Managed By     | Description                                                                                    |
| -------------- | -------------- | ---------------------------------------------------------------------------------------------- |
| `appVersion`   | Renovate       | Automatically updated by reading the `# renovate:` comment and emitting a `fix(deps):` commit. |
| `version`      | Release Please | Automatically bumped on `fix:` or `feat:` commits to `main`.                                   |
| `CHANGELOG.md` | Release Please | Automatically generated upon release.                                                          |
| Git tags       | Release Please | Automatically created on release.                                                              |

Never manually edit `version:`, `CHANGELOG.md`, or `.release-please-manifest.json`.

Use this exact format in `Chart.yaml` for Renovate to track application versions:

```yaml
# renovate: datasource=docker depName=<image> versioning=docker
appVersion: 'x.y.z'
```

## Chart Index

| Chart   | Path           | AGENTS.md                             | Description                       |
| ------- | -------------- | ------------------------------------- | --------------------------------- |
| netbird | charts/netbird | [AGENTS.md](charts/netbird/AGENTS.md) | NetBird mesh VPN — split topology (includes optional `netbird-operator` subchart) |

For detailed authoring guidelines, check [docs/chart-authoring.md](docs/chart-authoring.md).

## Adding the First/Next Chart

Follow this 10-step sequence to add a chart:

1. Create a new branch: `git checkout -b feat/add-<name>-chart`
2. Copy `chart-template/` to `charts/<name>/` and rename all instances of `chart-template` to `<name>`
3. Set the metadata in `Chart.yaml`: configure name, description, `version: 0.1.0`, and appVersion with the `# renovate:` comment
4. Annotate `values.yaml` with `# --` helm-docs comments and set `image.tag: ""`
5. Generate schema and documentation:
   ```bash
   helm-docs --chart-search-root charts/<name>
   helm schema -f charts/<name>/values.yaml --use-helm-docs
   ```
6. Register the package in Release Please configuration before making the commit:
   - In `release-please-config.json`, add the package under `packages`:
     ```json
     "charts/<name>": {
       "release-type": "helm",
       "component": "<name>",
       "package-name": "<name>"
     }
     ```
   - In `.release-please-manifest.json`, set the starting version:
     ```json
     "charts/<name>": "0.1.0"
     ```
7. Write `charts/<name>/AGENTS.md` by adapting the template
8. Stage the changes and commit: `git add . && git commit -m "feat(<name>): add initial chart"`
9. Open a PR, verify that CI passes, and merge to `main`
10. Once merged, Release Please opens a release PR. Merge it to publish to OCI, then make the GHCR package public using:
    ```bash
    gh api --method PATCH /user/packages/container/helm-charts%2F<name> -f visibility=public
    ```

## Local Tooling Prerequisites

Ensure the following tools are available on your system path:

- `helm` with `helm unittest` plugin
- `ct` (chart-testing)
- `kubeconform`
- `helm-docs`
- `helm schema` plugin
- `actionlint`
- `yamllint`
- `pnpm`
- `node` (version 20 or higher)
- `gh` (GitHub CLI)

Windows notes: Husky hooks require Git Bash or WSL. Test commit linting directly:

```bash
echo "feat(x): ok" | pnpm exec commitlint
```

## CI/CD Pipeline Overview

- **`ci.yaml`**: Triggers on push or PR to `main`.
  - `meta`: Runs Prettier, commitlint, yamllint, and actionlint.
  - `changed`: Detects modified charts.
  - `fixture`: Validates the `chart-template/` directory structure.
  - `chart-lint-test`: Lints and tests changed charts only.
  - `integration`: Launches a local Kubernetes kind cluster to perform a dry-run install.
  - `gated-install`: A gated job triggered manually, by schedule, or via the `run-integration` label.
- **`release.yaml`**: Runs Release Please to publish changed charts to GHCR OCI when `releases_created` is true.
- **`pr-labeler.yaml` / `labels-sync.yaml`**: Handles automatic PR labeling and syncs label configurations from `labels.yml`.

Note: Release Please PRs triggered by the default token might not trigger normal CI runs. Passing CI checks are not strictly required for Release Please PRs to be merged.

**Subchart dependencies**: Charts with subchart dependencies (e.g. `netbird` with `netbird-operator`) require `helm dependency build` before any helm operation. CI runs this automatically in `chart-lint-test`, `integration`, and `gated-install`. Locally: run `helm dependency build charts/<name>` after checkout. `Chart.lock` is committed; vendored `.tgz` files are git-ignored. When `operator.enabled=true`, cert-manager must be installed in the cluster.

**ct version-increment caveat**: `ct.yaml` sets `check-version-increment: true`. Since `version:` in `Chart.yaml` is Release-Please-owned and intentionally NOT bumped in feature PRs, the version-increment finding on a feature PR is expected and reconciled by the post-merge Release Please PR. Do not manually bump `version:` to silence this check.

## AGENTS.md Maintenance Rule

When making changes, keep instructions synchronized:

- Modify the root `AGENTS.md` for global workflows or toolchain updates.
- Modify `charts/<name>/AGENTS.md` for chart-specific guidelines.
- Create a new chart AGENTS.md using the standard template during chart creation.

## Definition of Done

Ensure the following checklist is completed before wrapping up:

- [ ] All files pass `pnpm exec prettier --check`
- [ ] Yaml files pass yamllint checks
- [ ] Helm chart lints cleanly via `helm lint`
- [ ] Schemas validate using `kubeconform`
- [ ] Re-run `helm-docs` and `helm schema` to ensure doc files are fully up to date
- [ ] Action workflows pass actionlint checks
- [ ] Commit messages follow the conventional style
- [ ] Relevant root and chart-specific `AGENTS.md` files are updated
