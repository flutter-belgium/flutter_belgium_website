---
parent: Decisions
nav_order: 35
title: "ADR-035: Meetup detail pages with slug-based routing"
status: accepted
date: 2026-05-30
decision-makers: Koen Van Looveren
---

# Meetup detail pages with slug-based routing

## Context and Problem Statement

The meetups listing page showed upcoming and past meetups as cards, but clicking a card had nowhere to go. To surface the meetup description, host details, and talk recordings in full, each meetup needed its own dedicated page.

## Decision Drivers

- Meetups contain rich content (description, program, talks) that does not fit on a card
- SEO: individual pages allow search engines to index meetup-specific content
- Consistency with the Made in Flutter Belgium feature, which already uses slug-based routes (ADR-021)

## Considered Options

- Modal/overlay on the meetups listing page
- Dedicated page per meetup at `/meetups/<slug>`
- Expand-in-place accordion on the listing page

## Decision Outcome

Chosen option: **Dedicated page per meetup at `/meetups/<slug>`**, where the slug is derived from the meetup title (e.g. `Flutter Belgium #26` → `flutter-belgium-26`).

Routes are generated at build time in `main.server.dart` by iterating `allMeetups` and registering a `Route` for each slug. The slug derivation reuses the existing `toSlug()` utility already used for Made in Flutter Belgium routes.

### Consequences

- Good, because each meetup has a canonical, shareable URL
- Good, because the detail page can render arbitrary content without the constraints of a card
- Good, because the pattern is already established by the Made in Flutter Belgium routes
- Neutral, because adding a meetup requires a rebuild to generate its route (static site constraint)
