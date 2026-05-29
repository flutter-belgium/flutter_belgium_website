# Building & deploying the website

## Triggering a rebuild

When content changes in the API, trigger a rebuild by sending a `repository_dispatch` event to GitHub Actions:

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_GITHUB_PAT" \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/flutter-belgium/flutter-belgium-website/dispatches \
  -d '{"event_type":"content-updated"}'
```

Replace `YOUR_GITHUB_PAT` with a fine-grained GitHub Personal Access Token scoped to this repository with **Actions: write** permission. Generate one at **GitHub → Settings → Developer settings → Fine-grained tokens**.

Replace `flutter-belgium/flutter-belgium-website` with the actual `{owner}/{repo}` of this repository.

## Manual build

```bash
fvm dart run jaspr_cli:jaspr build
```

Output is written to `build/jaspr/`.

## Custom domain

Configure `flutterbelgium.be` once in the repository **Settings → Pages → Custom domain**. GitHub Pages preserves this setting across deployments.
