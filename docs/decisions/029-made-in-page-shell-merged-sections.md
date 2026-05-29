---
parent: Decisions
nav_order: 29
title: "ADR-029: Made in Flutter Belgium page shell — merged hero and content into one section"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Made in Flutter Belgium page shell — merged hero and content into one section

## Context and Problem Statement

The `MadeInPageShell` component previously rendered two separate `section` elements: `made-in-hero` (title, subtitle, tab navigation) and `made-in-content` (the grid of items). Both were white with their own padding, creating a double-padded gap between the tab buttons and the content.

## Decision Drivers

- The hero and content are one logical unit — the tabs are navigation for the content directly below
- Double vertical padding between sections created unnecessary whitespace
- A single section is simpler to maintain and style

## Considered Options

- Keep two separate sections and reduce the gap with CSS overrides
- Merge into a single `section.made-in-page` with one inner container

## Decision Outcome

Chosen option: **Merge into a single section**, because the hero and content are semantically and visually one unit. The merged section uses `padding: 10rem 1.5rem 7rem` (generous top padding matching the home hero, standard bottom).

The tabs `div` uses an additional `made-in-tabs` class that adds `margin-bottom: 2rem` to separate the navigation from the content grid.

### Consequences

- Good, because the page feels like one cohesive block instead of two stacked sections
- Good, because there is a single `max-width` container governing alignment of both title and grid
- Neutral, because `made-in-hero` and `made-in-content` CSS classes are no longer used and can be removed
