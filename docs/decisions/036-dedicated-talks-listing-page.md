---
parent: Decisions
nav_order: 36
title: "ADR-036: Dedicated talks listing page"
status: accepted
date: 2026-05-30
decision-makers: Koen Van Looveren
---

# Dedicated talks listing page

## Context and Problem Statement

The home page displays up to three recent talk thumbnails via `TalksSection`. As the archive grows, users need a way to browse all recorded talks without being limited to the home page preview.

## Decision Drivers

- Users should be able to discover and rewatch any recorded talk, not just the three most recent ones
- The home page section should stay concise; a "View all talks" link is a natural companion
- Talks already exist as first-class data objects — a listing page requires no new data model work

## Considered Options

- Paginated extension of the home page section
- Dedicated `/talks` page listing all talks with video
- Embed all talks in the meetup detail pages only (no standalone page)

## Decision Outcome

Chosen option: **Dedicated `/talks` page**, rendering all talks that have a YouTube URL as thumbnail cards.

The page reuses the same `TalkCard` component used on the home page. Talks without a `youtubeUrl` are excluded — the page is scoped to published recordings only. The home page `TalksSection` gains a "View all talks" button linking to `/talks`.

### Consequences

- Good, because all recorded talks are discoverable from a single URL
- Good, because the component (`TalkCard`) and data flow are identical to the home page — no new abstractions needed
- Neutral, because the page shows all talks in a flat list without meetup grouping (future work if needed)
