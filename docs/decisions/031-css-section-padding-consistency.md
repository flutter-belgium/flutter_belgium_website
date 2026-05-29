---
parent: Decisions
nav_order: 31
title: "ADR-031: CSS section padding consistency — horizontal padding lives on the section"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# CSS section padding consistency — horizontal padding lives on the section

## Context and Problem Statement

Multiple sections had inconsistent left/right content alignment. Some sections applied horizontal padding at the section level, others at the inner container level, and some applied it at both. This caused content to start at different horizontal positions depending on the viewport width.

## Decision Drivers

- All non-full-width content blocks must align to the same horizontal grid
- The rule should be simple enough to apply consistently to new sections
- Full-width elements (carousels, strips) must be able to escape the horizontal padding

## Considered Options

- Horizontal padding on the inner container only (no section padding)
- Horizontal padding on the section only (inner container just does `max-width` + `margin: auto`)
- Mixed: both section and inner have horizontal padding

## Decision Outcome

Chosen option: **Horizontal padding on the section, not the inner container**, matching `--section-padding: 7rem 1.5rem`.

The inner `*-inner` divs use only `max-width: var(--container-max); margin: 0 auto` with no additional horizontal padding. Full-width elements (`.app-showcase-strip`, `.testimonials-rows`) use `margin: 0 -1.5rem` to break out of the section's horizontal padding.

Exception: sections that need full-width child elements (like About) must NOT use CSS variable shorthand with extra values (e.g. `padding: var(--section-padding) 0 0`) because the variable expands to `7rem 1.5rem 0 0`, zeroing the left padding. Use explicit three-value shorthand instead: `padding: 7rem 1.5rem 0`.

### Consequences

- Good, because all section content aligns consistently regardless of viewport width
- Good, because the rule is easy to follow for new sections
- Neutral, because full-width children require negative margins to escape the section padding
- Bad, because mixing CSS custom properties with additional shorthand values produces unexpected results — requires explicit values when overriding individual sides
