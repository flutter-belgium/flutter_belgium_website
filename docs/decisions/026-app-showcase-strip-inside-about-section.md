---
parent: Decisions
nav_order: 26
title: "ADR-026: App showcase strip embedded inside the About section"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# App showcase strip embedded inside the About section

## Context and Problem Statement

The "Made in Flutter Belgium" app showcase and the "About us" text are conceptually related — both communicate what the community is and does. Having them as two separate, visually independent sections created a disjointed reading experience.

## Decision Drivers

- The about text and the app strip should feel like one statement, not two
- The strip must remain full-width (edge-to-edge), even though the text is contained
- The grey section background should wrap both the text and the strip

## Considered Options

- Keep them as two separate sections in sequence
- Embed the strip inside the About section using negative margins to break out of the section's horizontal padding
- Combine into a new dedicated "Made in Flutter Belgium" section that replaces About

## Decision Outcome

Chosen option: **Embed the strip inside About using negative margins**, because it keeps the two pieces visually unified under one section background while allowing the strip to span the full viewport width.

The About section uses `padding: 7rem 1.5rem 0` (no bottom padding — the strip provides it). The `MadeInShowcaseSection` renders a `div.app-showcase-strip` with `margin: 0 -1.5rem` to escape the section padding and become full-width.

### Consequences

- Good, because About and the app strip share one visual block, reinforcing their connection
- Good, because the strip remains edge-to-edge without requiring a separate section
- Neutral, because `AboutSection` now requires `latestApps` and `madeInUrl` props
- Neutral, because the negative-margin technique requires the section padding to remain at `1.5rem` — if that changes, `app-showcase-strip` must be updated to match
