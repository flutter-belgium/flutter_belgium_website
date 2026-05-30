---
parent: Decisions
nav_order: 20
title: "ADR-020: Made in Flutter Belgium images downloaded as a CI step before build"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Made in Flutter Belgium images downloaded as a CI step before build

## Context and Problem Statement

The Made in Flutter Belgium data API provides image URLs (app icons, screenshots, company logos, developer avatars) hosted on `api.madein.flutterbelgium.be` and GitHub Avatars. The static site cannot reference external URLs at runtime — images must be bundled locally.

## Decision Drivers

- Images must be available as local static assets at `jaspr build` time
- External image URLs would require CORS headers and add runtime dependencies
- Developer avatars come from GitHub (`avatars.githubusercontent.com`), not the same API origin
- Images should not be committed to the website repository — they are build artefacts

## Considered Options

- Reference external URLs directly in `<img>` tags — runtime dependency, no local copy
- Commit images to the website repository — bloats the repo, duplicate of data repo
- Download images as a dedicated CI step before `jaspr build` runs

## Decision Outcome

Chosen option: **Download images as a CI step**, using `.github/workflows/scripts/download_made_in_images.dart`. The script:

1. Fetches the minimized list from the API
2. For each entry, fetches the full `info.json`
3. Downloads each image to `web/assets/made_in/{type}/{name}/{file}`

The `toLocalImagePath()` utility in `lib/util/made_in_utils.dart` maps API URLs to the local asset paths used in the Dart models, ensuring the same path logic is used in both the download script and the site.

GitHub Avatar URLs are mapped to `web/assets/made_in/developers/{username}/avatar.jpg`.

### Consequences

- Good, because images are served as local static assets with no external runtime dependency
- Good, because `toLocalImagePath()` is the single source of truth for the URL → path mapping
- Good, because images are not committed to the repository — the CI always fetches the latest
- Neutral, because every CI run re-downloads all images, even unchanged ones — acceptable given the low frequency of changes
