---
parent: Decisions
nav_order: 4
title: "ADR-004: Dedicated /branding page"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Dedicated /branding page

## Context and Problem Statement

Flutter Belgium has multiple logo variants and brand colours that community members, event hosts, and press need to use correctly. These assets are currently scattered or undiscoverable. Where should they live?

## Decision Drivers

- External parties (event hosts, sponsors, press) need easy access to correct logos
- The assets already exist as SVG files in `web/assets/`
- Download should be one click per asset
- Brand colours should be documented alongside the logos

## Considered Options

- Add a branding section to the existing homepage
- Create a dedicated `/branding` route
- Link to a third-party asset hosting service (e.g. Brandfolder)

## Decision Outcome

Chosen option: **Dedicated `/branding` route**, because it is self-contained, easy to link to from anywhere, and keeps all brand assets within the repository with no external dependency.

### Consequences

- Good, because the URL `flutterbelgium.be/branding` is shareable and memorable
- Good, because logos are served directly from the site — no third-party dependency
- Good, because the download button uses the native `download` attribute, requiring no server-side logic
- Good, because brand colours are documented next to the logos in one place
- Neutral, because the page must be manually updated when new assets are added to `web/assets/`
