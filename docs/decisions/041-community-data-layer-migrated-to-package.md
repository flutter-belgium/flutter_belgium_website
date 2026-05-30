---
parent: Decisions
nav_order: 41
title: "ADR-041: Community data layer migrated to flutter_belgium_data package and switched to AirTable"
status: accepted
date: 2026-05-30
decision-makers: Koen Van Looveren
---

# Community data layer migrated to flutter_belgium_data package and switched to AirTable

## Context and Problem Statement

Following ADR-040 (Made in Flutter Belgium data extracted to `flutter_belgium_data`), the website still contained local duplicates of the community data models (`Meetup`, `Talk`, `Person`, `PersonCompany`, `PersonSocialLinks`, `Company`, `Sponsor`, `TeamMember`, `Testimonial`, `CommunityLinks`) and the `FlutterBelgiumRepository` interface. All community data was served from a hardcoded `MockFlutterBelgiumRepository`. As the community grows, maintaining data in code is not scalable — meetup details, speaker bios, and company information all require a code change and full redeploy to update.

## Decision Drivers

- Community data (meetups, talks, people) changes frequently and should not require code changes to update
- The same model types are needed by multiple Flutter Belgium projects; duplicating them creates drift risk
- `flutter_belgium_data` already owns the Made in Flutter Belgium data layer; the community data layer belongs there too
- AirTable is the community's data management tool of choice; a direct integration removes the manual code-sync step

## Considered Options

- **Keep models local, add AirTable repository** — reduces drift over time but still duplicates model definitions
- **Migrate models and interface to the package, add AirTable repository** — single source of truth; aligns with the pattern established in ADR-040
- **External CMS (Contentful, Sanity, etc.)** — more powerful but introduces a paid dependency and significant integration overhead for a community project

## Decision Outcome

Chosen option: **Migrate models and interface to the package, add AirTable repository**.

The `flutter_belgium_data` package (`feat/airtable-data` branch) now owns the full community data layer. The website switches from `MockFlutterBelgiumRepository` to `AirtableFlutterBelgiumRepository`, reading live data from AirTable at build time. Configuration is provided via `AirTableConfig.fromEnvironment()` — if any of the six required env vars is absent the process fails immediately with a descriptive error listing the missing variables.

### What moved to the package

- `Meetup`, `Talk`, `Person`, `PersonCompany`, `PersonSocialLinks`, `Company`, `Sponsor`, `TeamMember`, `Testimonial`, `CommunityLinks` models
- `FlutterBelgiumRepository` abstract interface
- `AirtableFlutterBelgiumRepository` — fetches and caches data from four AirTable tables (meetups, talks, people, locations); resolves linked records in a single pass
- `AirTableConfig` and `AirTableConfig.fromEnvironment()` — reads six env vars (`AIRTABLE_TOKEN`, `AIRTABLE_BASE`, `AIRTABLE_TABLE_MEETUPS`, `AIRTABLE_TABLE_PEOPLE`, `AIRTABLE_TABLE_TALKS`, `AIRTABLE_TABLE_LOCATIONS`) and fails fast if any is missing
- `FlutterBelgiumDownloader.downloadFlutterBelgiumAssets()` — downloads avatars, logos, and meetup posters from AirTable attachment URLs to a local `assets/flutter_belgium/` tree

### What stays in the website

- `MockFlutterBelgiumRepository` — implements the package interface; kept as a reference and for component tests that need fixture data without a network call
- All UI components, pages, and routing — website-specific concerns

### Correction to ADR-040

ADR-040 listed `string_utils.dart` (`toSlug`) as staying in the website. That file has been deleted in this migration: `toSlug` is now exported from the package barrel and the website imports it from there.

### Consequences

- Good, because meetup and speaker data can be updated in AirTable without a code change
- Good, because all community models have a single definition shared across Flutter Belgium projects
- Good, because `AirTableConfig.fromEnvironment()` makes the fail-fast credential check reusable — the website no longer implements that logic itself
- Neutral, because the build now requires six AirTable env vars to be set; local development without credentials will fail at startup
- Neutral, because AirTable attachment URLs are temporary signed URLs — the asset-download step must run before each build to persist images locally before they expire
- Neutral, because `MockFlutterBelgiumRepository` must be kept in sync with the `FlutterBelgiumRepository` interface when new methods are added to the package
