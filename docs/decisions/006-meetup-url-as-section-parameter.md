---
parent: Decisions
nav_order: 6
title: "ADR-006: Meetup group URL passed as required parameter to PastMeetupsSection"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Meetup group URL passed as required parameter to PastMeetupsSection

## Context and Problem Statement

Past meetup cards always link to Meetup.com. Each `Meetup` model has an optional `meetupUrl` for a specific event page, but not every meetup will have one — especially historic ones. A reliable fallback to the group page is always needed.

## Decision Drivers

- Every past meetup card must always be clickable — non-clickable cards are not acceptable
- `communityLinks.meetupUrl` (the group page) is always available at build time
- The URL source should be explicit and verifiable at the component boundary, not silently optional

## Considered Options

- Rely solely on `Meetup.meetupUrl` and skip rendering a link if null
- Pass the full `CommunityLinks` object to `PastMeetupsSection`
- Add a required `meetupGroupUrl: String` parameter as a guaranteed fallback

## Decision Outcome

Chosen option: **Required `meetupGroupUrl: String` on `PastMeetupsSection`**, because the compiler enforces that a URL is always provided, and it keeps the component's dependency narrow (one URL string, not the entire `CommunityLinks` object).

Per-event URLs (`Meetup.meetupUrl`) take precedence when set; `meetupGroupUrl` is the fallback.

### Consequences

- Good, because it is impossible to render a past meetup section without a URL — the compiler enforces it
- Good, because per-event URLs are still supported via `Meetup.meetupUrl`
- Good, because the component does not depend on the full `CommunityLinks` object
- Neutral, because callers must always supply `meetupGroupUrl`, even when all meetups have per-event URLs
