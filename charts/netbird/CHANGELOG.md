# Changelog

## [0.2.7](https://github.com/fmauNeko/helm-charts/compare/netbird-v0.2.6...netbird-v0.2.7) (2026-06-20)


### Bug Fixes

* **deps:** update curlimages/curl to v8.20.0 ([#52](https://github.com/fmauNeko/helm-charts/issues/52)) ([4e439e3](https://github.com/fmauNeko/helm-charts/commit/4e439e348ded825fb89ef15f9a7920e08d9575ee))
* **deps:** update netbirdio/dashboard to v2.39.0 ([#53](https://github.com/fmauNeko/helm-charts/issues/53)) ([c5b792f](https://github.com/fmauNeko/helm-charts/commit/c5b792f20d15266b583c37002c1a21e1dbd75872))
* **deps:** update netbirdio/management to v0.73.1 ([#50](https://github.com/fmauNeko/helm-charts/issues/50)) ([3adf099](https://github.com/fmauNeko/helm-charts/commit/3adf099fd40e84fa2c21f8d97631fa08e1c70354))
* **netbird:** track dashboard image tag in Renovate ([6e721d9](https://github.com/fmauNeko/helm-charts/commit/6e721d9f9b79710849dbf70909e4a2b959fb59a1))

## [0.2.6](https://github.com/fmauNeko/helm-charts/compare/netbird-v0.2.5...netbird-v0.2.6) (2026-06-18)


### Bug Fixes

* **deps:** update netbirdio/management to v0.73.0 ([#43](https://github.com/fmauNeko/helm-charts/issues/43)) ([bee8a25](https://github.com/fmauNeko/helm-charts/commit/bee8a25a26a4b6c129ee3a9e1e710214846695c5))

## [0.2.5](https://github.com/fmauNeko/helm-charts/compare/netbird-v0.2.4...netbird-v0.2.5) (2026-06-06)


### Bug Fixes

* **netbird:** stream management logs to console ([#30](https://github.com/fmauNeko/helm-charts/issues/30)) ([422d2eb](https://github.com/fmauNeko/helm-charts/commit/422d2eb302bc39baf8996c79ef10073e7ea8ea85))

## [0.2.4](https://github.com/fmauNeko/helm-charts/compare/netbird-v0.2.3...netbird-v0.2.4) (2026-06-06)


### Bug Fixes

* **netbird:** rely on OIDC discovery for JWKS URI ([#28](https://github.com/fmauNeko/helm-charts/issues/28)) ([0a5d7ca](https://github.com/fmauNeko/helm-charts/commit/0a5d7ca6f94db616c92c684826c1f96fc159fc52))

## [0.2.3](https://github.com/fmauNeko/helm-charts/compare/netbird-v0.2.2...netbird-v0.2.3) (2026-06-06)


### Bug Fixes

* **netbird:** route ws-proxy to signal/management and gRPC to :80 ([#23](https://github.com/fmauNeko/helm-charts/issues/23)) ([35224c1](https://github.com/fmauNeko/helm-charts/commit/35224c1fa9dbeefecc9d2e67de8a5d5f9bf1c589))

## [0.2.2](https://github.com/fmauNeko/helm-charts/compare/netbird-v0.2.1...netbird-v0.2.2) (2026-06-06)


### Bug Fixes

* **netbird:** render stun and turn hosts correctly ([d484ef7](https://github.com/fmauNeko/helm-charts/commit/d484ef790cfd622e28cee7c571dacf12c60fa7a8))
* **netbird:** render stun and turn hosts correctly ([#21](https://github.com/fmauNeko/helm-charts/issues/21)) ([ee0928b](https://github.com/fmauNeko/helm-charts/commit/ee0928b55942a3214e262314e03830c9d3537d34))

## [0.2.1](https://github.com/fmauNeko/helm-charts/compare/netbird-v0.2.0...netbird-v0.2.1) (2026-06-03)


### Bug Fixes

* **netbird:** allow overriding advertised signal URI ([54a649a](https://github.com/fmauNeko/helm-charts/commit/54a649a8bee283b744f5b71dc2d9140a9b906dc4))
* **netbird:** allow overriding advertised signal URI ([f1d7452](https://github.com/fmauNeko/helm-charts/commit/f1d7452487140091f3bb08dc02d0c8e478ee2a2e))
* **netbird:** allow overriding advertised signal URI ([#6](https://github.com/fmauNeko/helm-charts/issues/6)) ([54a649a](https://github.com/fmauNeko/helm-charts/commit/54a649a8bee283b744f5b71dc2d9140a9b906dc4))

## [0.2.0](https://github.com/fmauNeko/helm-charts/compare/netbird-v0.1.0...netbird-v0.2.0) (2026-06-02)


### Features

* **netbird:** add initial chart ([9c55049](https://github.com/fmauNeko/helm-charts/commit/9c550497ba31be00b4256ee1fe55814bd9a68a0c))
* **netbird:** add initial NetBird Helm chart ([13f33b7](https://github.com/fmauNeko/helm-charts/commit/13f33b718dcf475d38e84080a94f1cb4a333759d))
* **netbird:** add initial NetBird Helm chart ([#1](https://github.com/fmauNeko/helm-charts/issues/1)) ([13f33b7](https://github.com/fmauNeko/helm-charts/commit/13f33b718dcf475d38e84080a94f1cb4a333759d))


### Bug Fixes

* **netbird:** correct dashboard image tag and redirect URI format ([8a27ccd](https://github.com/fmauNeko/helm-charts/commit/8a27ccde449e0c427fde1064015709f45d3b411f))
* **netbird:** fix Zitadel IdP manager configuration ([81e810f](https://github.com/fmauNeko/helm-charts/commit/81e810fc005f335bf0905d9a0a5330deaf022451))
* **netbird:** remove relay liveness/readiness probes ([cae30f7](https://github.com/fmauNeko/helm-charts/commit/cae30f710c327d53bb7303cbeeb1803d822f7f53))
