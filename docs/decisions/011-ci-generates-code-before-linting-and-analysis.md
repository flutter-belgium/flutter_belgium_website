---
parent: Decisions
nav_order: 11
title: "ADR-011: CI generates code before linting and analysis"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# CI generates code before linting and analysis

## Context and Problem Statement

Jaspr uses `jaspr_builder` to generate `*.options.dart` files (e.g. `main.client.options.dart`, `main.server.options.dart`) at build time. These files are imported by `main.client.dart` and `main.server.dart`. When `dart analyze` ran in CI without the generated files present, it produced errors about missing imports and undefined identifiers, causing all CI runs on clean checkouts to fail.

## Decision Drivers

- `dart analyze` must pass on a clean checkout with no local build artifacts
- Generated files should not be committed to the repository
- The generation step must be fast enough not to significantly slow down CI

## Considered Options

- Commit the generated `*.options.dart` files to the repository
- Add a `dart run build_runner build` step in CI before `dart analyze`
- Exclude the generated files from analysis using `analysis_options.yaml`

## Decision Outcome

Chosen option: **`dart run build_runner build --delete-conflicting-outputs` in CI before analyze**, because generated files belong in `.gitignore`, not in source control. Running `build_runner` is the standard approach and takes only a few seconds.

### Consequences

- Good, because generated files are never committed — the repository stays clean
- Good, because this matches the behaviour of `jaspr serve` and `jaspr build` locally (both run `build_runner` internally)
- Neutral, because CI takes a few extra seconds to generate files on each run
- Bad, because forgetting to run `build_runner` locally before `dart analyze` will produce the same errors on a developer's machine

### Confirmation

The `validate` job in `.github/workflows/deploy.yml` includes a `Generate code` step immediately after `dart pub get` and before `dart format` and `dart analyze`.
