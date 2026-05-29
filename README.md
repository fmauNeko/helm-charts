# helm-charts

Personal Helm chart library published as OCI artifacts to GitHub Container Registry (GHCR).

## Charts

| Chart                  | Description | Version |
| ---------------------- | ----------- | ------- |
| _(charts coming soon)_ | —           | —       |

Each chart has its own `README.md` with values documentation. See the [chart-template](chart-template/) for the authoring standard.

## Usage

### Install a chart

```bash
helm install <release-name> oci://ghcr.io/fmauneko/helm-charts/charts/<chart-name> \
  --version <x.y.z> \
  --values my-values.yaml
```

### Pull a chart

```bash
helm pull oci://ghcr.io/fmauneko/helm-charts/charts/<chart-name> --version <x.y.z>
```

### Show chart values

```bash
helm show values oci://ghcr.io/fmauneko/helm-charts/charts/<chart-name> --version <x.y.z>
```

## Releases

Charts are versioned independently using [Release Please](https://github.com/googleapis/release-please). Each chart follows [Semantic Versioning](https://semver.org/):

- **Patch** (`0.0.x`): Upstream app version update (automated by Renovate), bug fixes
- **Minor** (`0.x.0`): New chart features, new optional values
- **Major** (`x.0.0`): Breaking changes to values or behaviour

Chart packages are published to GHCR as OCI artifacts on every release.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md).

To add a new chart, follow the 10-step sequence in [AGENTS.md](AGENTS.md#adding-the-firstnext-chart).

## GHCR Package Visibility

GHCR packages are **private by default** when first pushed. After a chart's first release, set the package to public:

```bash
# Replace <chart-name> with the actual chart name (e.g., netbird)
gh api \
  --method PATCH \
  -H "Accept: application/vnd.github+json" \
  /user/packages/container/helm-charts%2F<chart-name> \
  -f visibility=public
```

Or go to: `https://github.com/fmauNeko?tab=packages` → select the package → Package Settings → Change visibility.

## License

[MIT](LICENSE)
