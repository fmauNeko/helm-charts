# Contributing

## Setup

```bash
pnpm install
```

## Making changes

1. Branch from `main`: `git checkout -b feat/<scope>` or `fix/<scope>`
2. Make changes following the conventions in [AGENTS.md](AGENTS.md)
3. For chart changes, follow the [Chart Authoring Standard](docs/chart-authoring.md)
4. Commit using Conventional Commits: `pnpm run commit`
5. Open a PR, which will be auto-labeled and title-linted

## Adding a new chart

See the **Adding the First/Next Chart** section in [AGENTS.md](AGENTS.md) for the full 10-step sequence.

## Code style

- All files formatted with Prettier: `pnpm exec prettier --write .`
- YAML files linted with yamllint: `yamllint -c .yamllint.yaml <file>`
- Workflows linted with actionlint: `actionlint <workflow.yaml>`
