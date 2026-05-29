---
parent: Decisions
nav_order: 18
title: "ADR-018: Made in Flutter Belgium — curated collection of Belgian Flutter work"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Made in Flutter Belgium — curated collection of Belgian Flutter work

## Context and Problem Statement

Flutter Belgium is a community of developers, but the website only represented the meetup side (events, talks, sponsors, team). There was no place to celebrate the actual work the community produces: apps shipped to the stores, companies building with Flutter, and individual developers contributing to the ecosystem.

## Decision Drivers

- Give the community something to be proud of and point to
- Attract Flutter developers and companies to the community by showing what peers are building
- Provide social proof that Flutter is actively used in Belgium at a professional level

## Considered Options

- External listing (e.g. a GitHub README or a separate microsite)
- A static hardcoded page on the existing website
- A fully dynamic section backed by a dedicated data API, integrated into the existing site

## Decision Outcome

Chosen option: **Dynamic section backed by a dedicated API**, integrated into the existing Jaspr site. Three sub-sections cover the full ecosystem:

- `/made-in-flutter-belgium/apps` — Flutter apps published by Belgian developers or companies
- `/made-in-flutter-belgium/companies` — Belgian companies using Flutter in production
- `/made-in-flutter-belgium/developers` — Individual Belgian Flutter developers

Each has a list view and a detail page. A showcase strip on the home page surfaces the latest apps. The data is maintained in a separate GitHub repository and served via `api.madein.flutterbelgium.be`.

### Consequences

- Good, because the community has a public, linkable place to showcase their work
- Good, because the feature is data-driven — adding a new app/company/developer requires no code change
- Good, because it lives on the existing domain and shares branding with the rest of the site
- Neutral, because maintaining the data repository is ongoing work separate from this codebase
