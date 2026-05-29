---
parent: Decisions
nav_order: 17
title: "ADR-017: Manual workflow trigger for collaborators"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Manual workflow trigger for collaborators

## Context and Problem Statement

The site rebuilds automatically on push to main and via `repository_dispatch` when API content changes. However, there are situations where a collaborator needs to force a rebuild without making a code change — for example after a configuration fix, to recover from a failed deploy, or to test a change in the deployment pipeline.

## Decision Drivers

- Collaborators must be able to trigger a rebuild without pushing dummy commits
- The trigger must not be accessible to the public — only repository collaborators with write access
- No additional infrastructure (webhooks, scripts, tokens) should be required for ad-hoc runs

## Considered Options

- Push an empty commit to main to trigger the existing push handler
- Add a `workflow_dispatch` event to the workflow
- Create a separate workflow for manual runs only

## Decision Outcome

Chosen option: **`workflow_dispatch`**, because it adds a "Run workflow" button directly in the GitHub Actions UI at no cost. Only users with write access to the repository can see and use the button — no extra credentials or tooling required.

```yaml
on:
  workflow_dispatch:
```

When triggered manually, the full pipeline runs: validate → build → deploy.

### Consequences

- Good, because no dummy commits are needed to force a rebuild
- Good, because access is automatically scoped to repository collaborators — GitHub enforces this
- Good, because it reuses the exact same pipeline as automated triggers — no divergence
- Neutral, because the button is only accessible via the GitHub web UI or the GitHub CLI (`gh workflow run`)

### Confirmation

The `workflow_dispatch` event is listed under `on:` in `.github/workflows/deploy.yml`. The "Run workflow" button appears on the Actions tab of the repository for users with write access.
