---
parent: Decisions
nav_order: 13
title: "ADR-013: GitHub Pages deployed via official GitHub Actions"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# GitHub Pages deployed via official GitHub Actions

## Context and Problem Statement

The site is hosted on GitHub Pages. Deployment must be triggered from CI after a successful build. How should the built output be pushed to GitHub Pages?

## Decision Drivers

- Deployment should use the officially supported GitHub mechanism, not a third-party action
- The deployment URL should be visible in the GitHub Actions UI
- The workflow must have the correct permissions to write to Pages

## Considered Options

- `peaceiris/actions-gh-pages` — pushes build output to a `gh-pages` branch
- Official GitHub Actions: `actions/configure-pages` + `actions/upload-pages-artifact` + `actions/deploy-pages`

## Decision Outcome

Chosen option: **Official GitHub Actions**, because they are maintained by GitHub, require no third-party trust, expose the deployment URL via `steps.deployment.outputs.page_url`, and work with the GitHub Pages environment protection rules.

```yaml
permissions:
  contents: read
  pages: write
  id-token: write

environment:
  name: github-pages
  url: ${{ steps.deployment.outputs.page_url }}
```

### Consequences

- Good, because no third-party action has write access to the repository
- Good, because the live URL appears in the Actions UI after each deploy
- Good, because the `github-pages` environment enables branch protection and deployment history in GitHub
- Neutral, because the workflow requires explicit `pages: write` and `id-token: write` permissions
