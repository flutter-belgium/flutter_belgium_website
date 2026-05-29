---
parent: Decisions
nav_order: 14
title: "ADR-014: Dart build artifacts are removed before deployment"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Dart build artifacts are removed before deployment

## Context and Problem Statement

`jaspr build` outputs the static site to `build/jaspr/` but also writes Dart tooling artifacts into the same directory. Uploading the full directory to GitHub Pages results in thousands of Dart source files being deployed as part of the website, which is incorrect and significantly inflates the artifact size.

## Decision Drivers

- Only web content (HTML, CSS, assets) should be deployed
- Dart source files and tooling metadata have no place in a public web deployment
- The cleanup must be explicit and auditable in the workflow

## Considered Options

- Deploy the full `build/jaspr/` directory as-is
- Delete known artifact directories and files before uploading
- Reconfigure `jaspr build` output (not supported)

## Decision Outcome

Chosen option: **Delete known artifacts before upload**, because it is explicit, requires no build tool changes, and is easy to extend if new artifacts appear.

The following are removed after `jaspr build` and before `upload-pages-artifact`:

| Path | Reason |
|------|--------|
| `build/jaspr/packages/` | Dart dependency source files (100+ packages) |
| `build/jaspr/.dart_tool/` | Dart tooling configuration |
| `build/jaspr/.build.manifest` | build_runner metadata |
| `build/jaspr/main.client.dart` | Dart source file copied by the builder |

### Consequences

- Good, because the deployed artifact contains only web content
- Good, because the removal step is visible and auditable in the workflow YAML
- Neutral, because the list must be updated if `jaspr build` introduces new artifact paths in future versions
