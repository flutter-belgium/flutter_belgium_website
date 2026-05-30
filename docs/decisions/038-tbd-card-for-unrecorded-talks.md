---
parent: Decisions
nav_order: 38
title: "ADR-038: TBD card for talks without a YouTube recording"
status: accepted
date: 2026-05-30
decision-makers: Koen Van Looveren
---

# TBD card for talks without a YouTube recording

## Context and Problem Statement

A meetup's talk list is known in advance (the program is fixed), but recordings are only available after the event. The meetup detail page should reflect the full program, including slots that have not yet been recorded, rather than silently omitting them.

## Decision Drivers

- Transparency: visitors should see the full program even when videos are not yet published
- A `Talk` with `youtubeUrl == null` is a valid state (announced but unrecorded), not an error
- The talks grid should not appear empty or partial without explanation

## Considered Options

- Hide talks without a YouTube URL (status quo before this decision)
- Show a "coming soon" placeholder card
- Show a TBD placeholder card

## Decision Outcome

Chosen option: **`TbdTalkCard` rendered for any `Talk` with `youtubeUrl == null`**.

The meetup detail talks grid iterates `meetup.talks` and branches on `talk.thumbnailUrl != null`: truthy renders a `TalkCard` (thumbnail + YouTube link), falsy renders a `TbdTalkCard` (styled placeholder with bold "TBD" label and slot number). The global talks page and home page section continue to show only talks with a YouTube URL, since those surfaces are scoped to published recordings.

### Consequences

- Good, because the full meetup program is visible even before recordings are published
- Good, because the TBD state is explicit — no silent omission
- Good, because `TalkCard` remains a pure "has video" component; the TBD case is handled by a separate component
- Neutral, because the TBD card requires minimal CSS styling to match the grid layout
