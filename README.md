# php-cake-dev

PHP docker image for CakePHP development

## GitHub Action

Der Workflow in `.github/workflows/docker-image.yml` baut das Docker-Image aus dem `Dockerfile`.

- Bei `pull_request` auf `main`: nur Build (kein Push)
- Bei `push` auf `main`: Build + Push nach GHCR
- Manuell via `workflow_dispatch`
- Es wird immer eine Matrix gebaut: PHP `8.1`, `8.2`, `8.3`

Images werden mit Tags `8.1`, `8.2`, `8.3` getaggt und auf GHCR gepusht:

`ghcr.io/gregor-j/php-cake-dev:${PHP_VERSION}`
