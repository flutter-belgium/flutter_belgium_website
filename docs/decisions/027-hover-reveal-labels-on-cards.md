---
parent: Decisions
nav_order: 27
title: "ADR-027: Hover-reveal labels on app and developer cards"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Hover-reveal labels on app and developer cards

## Context and Problem Statement

App and developer icon grids are visually dense. Showing every name below every icon at all times creates visual clutter and competes with the icons. However, names are useful to identify what you are hovering over before clicking.

## Decision Drivers

- Grid should feel clean and icon-focused at rest
- Names must be fully readable without truncation when revealed
- The label must not affect the grid layout (no layout shifts, no cell size changes)
- Must work in both the home page showcase strip and the made-in grid pages

## Considered Options

- Always-visible name below each icon (current state before this decision)
- Tooltip on hover
- Label absolutely positioned, hidden by default, revealed on hover with fade + slide animation

## Decision Outcome

Chosen option: **Absolutely positioned label, revealed on hover**, because it keeps the grid clean at rest and shows the full name on demand without affecting layout.

Implementation pattern (identical for both showcase strip and made-in grid):
- Parent card: `position: relative; display: block` (not flex — flex containers clip absolute overflow)
- Label: `position: absolute; top: 100%; left: 50%; transform: translateX(-50%) translateY(-4px); white-space: nowrap; opacity: 0`
- On hover: `opacity: 1; transform: translateX(-50%) translateY(0)`

The `white-space: nowrap` with no `max-width` or `overflow: hidden` allows the label to be as wide as the text needs, overflowing the card's box symmetrically.

### Consequences

- Good, because the grid is visually clean at rest
- Good, because the full app or developer name is always readable on hover
- Good, because no layout shifts occur — the label is out of flow
- Neutral, because labels of edge-column cards may overlap the viewport edge on very narrow screens
