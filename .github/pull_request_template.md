## Description

<!-- Describe the change and why it's needed -->

## Checklist

- [ ] PR title follows Conventional Commits format (e.g. `feat(netbird): add initial chart`)
- [ ] `AGENTS.md` updated if repo structure or tooling changed
- [ ] If a chart was changed:
  - [ ] `helm lint --strict charts/<name>/` passes
  - [ ] `helm template charts/<name>/` renders without errors
  - [ ] `helm-docs --chart-search-root charts/<name>` — `README.md` regenerated
  - [ ] `helm schema -input charts/<name>/values.yaml` — `values.schema.json` regenerated
  - [ ] Chart `AGENTS.md` updated if values/behavior changed
- [ ] No secrets committed
