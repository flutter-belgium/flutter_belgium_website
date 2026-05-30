---
parent: Decisions
nav_order: 19
title: "ADR-019: Made in Flutter Belgium data fetched at build time from external API"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Made in Flutter Belgium data fetched at build time from external API

## Context and Problem Statement

The Made in Flutter Belgium collection (apps, companies, developers) is stored in a separate data repository and served via `api.madein.flutterbelgium.be`. The site needs to integrate this data. The question is when and how to fetch it.

## Decision Drivers

- The site is statically generated (Jaspr SSG) — there is no server runtime to fetch data on request
- The data changes infrequently (new entries a few times per month)
- Fetched images must be bundled with the static site to avoid CORS and external image dependencies
- A separate repository for the data allows community contributions without touching website code

## Considered Options

- Fetch at runtime (JavaScript client-side) — requires JS and breaks SSG/SEO
- Embed data as a hardcoded Dart file — loses the separate data repository benefit
- Fetch at build time via `HttpMadeInFlutterBelgiumRepository` during `main()` — data is available for SSG

## Decision Outcome

Chosen option: **Fetch at build time**, using `HttpMadeInFlutterBelgiumRepository` which calls `api.madein.flutterbelgium.be` during the Jaspr build process. All data (apps, companies, developers) is resolved before `runApp()`, so every route — including detail pages — is generated with real data.

A separate `MadeInFlutterBelgiumRepository` interface and `MockMadeInFlutterBelgiumRepository` implementation are provided for local development without network access, following the same repository pattern used for the main site data.

The API structure:
- `GET /projects/minimized_all.json` → list of names
- `GET /projects/:name/info.json` → full app data
- Same pattern for `/companies` and `/developers`

### Consequences

- Good, because the static site has full SEO coverage for every detail page
- Good, because image assets are downloaded and bundled locally (see ADR-029)
- Good, because local development can run against mock data without network access
- Neutral, because a rebuild and redeploy is required to reflect data changes — acceptable for this update frequency
- Neutral, because build time grows with the number of entries due to sequential API calls
