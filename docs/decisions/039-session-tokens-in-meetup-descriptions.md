---
parent: Decisions
nav_order: 39
title: "ADR-039: Session tokens in meetup descriptions resolved to bold talk info"
status: accepted
date: 2026-05-30
decision-makers: Koen Van Looveren
---

# Session tokens in meetup descriptions resolved to bold talk info

## Context and Problem Statement

Meetup descriptions include the event program as free-form text (e.g. `19:00 — <session-1>`). The actual talk title and speaker are stored on the `Talk` model. Duplicating this information in the description string would require keeping two copies in sync; instead, the description uses placeholder tokens that are resolved at render time.

## Decision Drivers

- Talk title and speaker are authoritative on the `Talk` object — they should not be duplicated in the description string
- The description is authored once and remains valid even before talks are confirmed (tokens resolve to "TBD")
- Resolved session info should be visually distinct from surrounding description text

## Considered Options

- Duplicate talk info directly in the description string (no tokens)
- Tokens replaced with plain text at render time
- Tokens replaced with bold HTML at render time using Jaspr's `b()` element

## Decision Outcome

Chosen option: **`<session-N>` tokens resolved to bold Jaspr components at render time**.

`MeetupDetailPage._buildDescription()` uses a `RegExp` to find all `<session-N>` tokens, replaces each with a `b([Component.text(label)])` Jaspr component, and surrounds it with plain-text `Component.text` nodes for the surrounding description. If `meetup.talks` has no entry at index `N-1`, the token resolves to bold `"TBD"`. The returned `List<Component>` is passed directly as the children of the description `<p>` element.

Slot numbers cycle 1–20 (`(index % 20) + 1`) on the meetup detail talks grid, matching the `<session-N>` numbering convention.

### Consequences

- Good, because talk info is single-sourced on `Talk` — no synchronisation needed
- Good, because descriptions remain valid before talks are confirmed (TBD fallback)
- Good, because bold rendering makes session info scannable in a dense program block
- Neutral, because the description field must be authored with `<session-N>` tokens to get substitution; plain descriptions are rendered as-is
