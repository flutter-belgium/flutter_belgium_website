# Flutter Belgium Website

The official website for [Flutter Belgium](https://flutterbelgium.be) — the Belgian Flutter community.

Built with [Jaspr](https://github.com/schultek/jaspr) and hosted on GitHub Pages.

## Prerequisites

This project uses [FVM](https://fvm.app) to pin the Flutter/Dart SDK version. Install it once:

```bash
dart pub global activate fvm
fvm install
```

## Local development

```bash
# Install packages
fvm dart pub get

# Start dev server (hot reload at http://localhost:8080)
fvm dart run jaspr_cli:jaspr serve
```

## Deployment

See [docs/BUILD_WEBSITE.md](docs/BUILD_WEBSITE.md) for how to trigger a rebuild and deploy the site.

## Swapping mock data for the real API

When the API Dart package is published:

1. Add it to `pubspec.yaml` and run `fvm dart pub get`
2. In `lib/main.server.dart`, replace:
   ```dart
   final repository = MockFlutterBelgiumRepository();
   ```
   with:
   ```dart
   final repository = ApiFlutterBelgiumRepository();
   ```
3. Delete `lib/data/models/` and `lib/data/repositories/mock_flutter_belgium_repository.dart`

## Brand assets

All brand assets are available at [flutterbelgium.be/branding](https://flutterbelgium.be/branding).

SVG files are in `web/assets/`:

| File | Description |
|---|---|
| `logo-default.svg` | Colored logo — use on light backgrounds |
| `logo-horizontal.svg` | Colored horizontal logo — use on light backgrounds |
| `logo-mark.svg` | Colored logomark only |
| `logo-full-white.svg` | Full white logo — use on dark backgrounds |
| `logo-white.svg` | White logo — use on sky/colored backgrounds |
| `logo-mark-white.svg` | White logomark only — use on dark backgrounds |
