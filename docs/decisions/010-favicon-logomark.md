---
parent: Decisions
nav_order: 10
title: "ADR-010: Favicon uses the logomark"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Favicon uses the logomark

## Context and Problem Statement

The site needs a favicon that is recognisable in browser tabs and bookmarks, where icons render at 16×16 to 32×32 pixels. Flutter Belgium has multiple logo variants — which one should be used?

## Decision Drivers

- At favicon size, a wordmark becomes unreadable
- The logomark (symbol only) is distinct and recognisable at any size
- The favicon should match the brand identity

## Considered Options

- Full horizontal logo (`logo-default.svg`) — includes wordmark
- Logomark only (`logo-mark.svg`) — symbol only

## Decision Outcome

Chosen option: **`logo-mark.svg`**, because the logomark is the portion of the brand designed to work at small sizes. The full logo with wordmark is illegible below ~100px wide.

### Consequences

- Good, because the favicon is clear and recognisable at all standard sizes
- Good, because the logomark is already used in other small-size contexts (testimonial card avatar placeholder)
- Neutral, because the wordmark is not visible in the browser tab — only the symbol
