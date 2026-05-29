---
parent: Decisions
nav_order: 34
title: "ADR-034: Package imports over relative imports"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Package imports over relative imports

## Context and Problem Statement

Dart supports two styles of importing files within the same package: relative imports (`'../components/footer.dart'`) and package imports (`'package:flutter_belgium_website/components/footer.dart'`). The codebase had grown to use relative imports exclusively, which made file locations implicit and imports fragile to directory restructuring.

## Decision Drivers

- Imports should be unambiguous regardless of where the importing file lives
- Moving or renaming a file should not require updating all relative paths in files that import it
- Consistency: a single style throughout the codebase is easier to follow and review
- Dart's official style guide recommends package imports for files within the same package when the project grows beyond a few files

## Considered Options

- Relative imports everywhere (status quo)
- Package imports everywhere for files within `lib/`
- Mixed: relative for same-directory, package for cross-directory

## Decision Outcome

Chosen option: **Package imports for all files within `lib/`**, using `package:flutter_belgium_website/` as the prefix.

All 125 relative import statements across the codebase were converted in a single pass using an automated script. The rule applies to every file under `lib/` — both same-directory imports (e.g. `'legal_page.dart'` → `'package:flutter_belgium_website/pages/legal_page.dart'`) and cross-directory imports.

Imports for external packages (`package:jaspr/...`, `package:jaspr_router/...`) and Dart SDK imports (`dart:...`) are unaffected.

### Consequences

- Good, because import paths are absolute and unambiguous — the full location is visible at a glance
- Good, because refactoring file locations requires updating only the moved file's own imports, not all its callers
- Good, because consistent style reduces review friction
- Neutral, because package imports are more verbose than short relative imports in the same directory
