---
parent: Decisions
nav_order: 5
title: "ADR-005: Meetup cards are fully clickable links"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Meetup cards are fully clickable links

## Context and Problem Statement

Past meetup cards need to be fully clickable and open the corresponding Meetup.com event page. The entire card surface — image, date, title, and host — should act as a single tap target with correct pointer cursor behaviour, without requiring JavaScript.

## Decision Drivers

- The entire card surface must be clickable
- Cursor must change to pointer on hover without extra CSS hacks
- Must work without JavaScript (static site)
- Must produce semantically valid HTML

## Considered Options

- Wrap the card content in an `<article>` and place a `<a>` inside pointing to the event
- Use an `<article>` as root and add a full-cover `<a>` via absolute positioning
- Render the card root element as an `<a>` tag directly

## Decision Outcome

Chosen option: **Render the card root as an `<a>` element**, because making the link the outermost element means the entire card surface is natively clickable with correct cursor, keyboard navigation, and semantics — with no extra CSS required.

### Consequences

- Good, because the entire card is a single native link — correct cursor, keyboard navigation, and accessibility out of the box
- Good, because no JavaScript required
- Neutral, because the root element is `<a>` rather than `<article>`, which is a minor semantic trade-off (both are valid for a card component in HTML5)

### Confirmation

`_MeetupCard` renders `a(children, href: meetupUrl, target: Target.blank, ...)` as its root element. `meetupUrl` is a required `String` — it is always non-null at the call site.
