---
parent: Decisions
nav_order: 40
title: "ADR-040: Made in Flutter Belgium data layer extracted to shared package"
status: accepted
date: 2026-05-30
decision-makers: Koen Van Looveren
---

# Made in Flutter Belgium data layer extracted to shared package

## Context and Problem Statement

The website contained its own copies of the Made in Flutter Belgium models (`MadeInApp`, `MadeInCompany`, `MadeInDeveloper`, and their `Ref`/`Links` variants), repository interface, HTTP repository, and `toLocalImagePath`/`toSlug` utilities. As more projects in the Flutter Belgium ecosystem need to work with the same dataset, duplicating this logic per project creates maintenance risk — a schema change or API update would require parallel edits in every consumer.

## Decision Drivers

- Multiple Flutter Belgium projects (website, app, CLI tooling) need access to the same Made in Flutter Belgium data structures
- A schema or API change should only need to be fixed in one place
- The package should be independently testable and versionable

## Considered Options

- **Keep the data layer in each project** — full independence but logic diverges over time; breaking API changes must be applied everywhere manually
- **Extract to a shared Dart package (`flutter_belgium_data`)** — single source of truth for models, repository, HTTP client, utilities, and asset-download tooling
- **Monorepo with path dependencies** — would keep projects in sync but couples release cycles and complicates CI for consumers outside the monorepo

## Decision Outcome

Chosen option: **Extract to a shared package**, consumed via a git dependency on `https://github.com/flutter-belgium/flutter_belgium_data.git`.

The website now imports `package:flutter_belgium_data/flutter_belgium_data.dart` for all Made in Flutter Belgium types and the `FlutterBelgiumData` facade. The previously inline HTTP repository, mock repository base interface, models, and utilities have been deleted from the website.

### What the package provides

- `MadeInApp`, `MadeInCompany`, `MadeInDeveloper` and their `Ref`/`Links` variants
- `MadeInFlutterBelgiumRepository` interface and `HttpMadeInFlutterBelgiumRepository` implementation
- `toLocalImagePath` and `toSlug` utilities
- `FlutterBelgiumData` facade (`getMadeInApps()`, `getMadeInCompanies()`, `getMadeInDevelopers()`)
- `FlutterBelgiumTools.downloadMadeInAssets()` for CI asset-download scripts

### What stays in the website

- `MockMadeInFlutterBelgiumRepository` — implements the package's interface; kept in the website because mock data is website-specific
- `string_utils.dart` — `toSlug` for meetup slugs; unrelated to the Made in Flutter Belgium domain
- All UI components, pages, and routing — website-specific concerns

### Consequences

- Good, because models, parsing logic, and utilities exist in one place; a schema change is a single PR
- Good, because the asset-download CI script is now a 4-line file delegating to the package tool
- Good, because new consumers can add a git dependency and immediately get the full data layer
- Neutral, because the website now has a network dependency on a separate GitHub repository at `dart pub get` time; CI must be able to reach GitHub
- Neutral, because the mock repository must be kept in sync with the package interface when new methods are added
