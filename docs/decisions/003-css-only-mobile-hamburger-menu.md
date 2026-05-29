---
parent: Decisions
nav_order: 3
title: "ADR-003: CSS-only mobile hamburger menu"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# CSS-only mobile hamburger menu

## Context and Problem Statement

On mobile the navbar links are hidden (`display: none` at ≤768px). Users on mobile have no way to navigate to page sections. A hamburger menu is needed. How should the open/close toggle be implemented given that the site uses Jaspr in static mode with no client-side JavaScript?

## Decision Drivers

- Jaspr is configured in `mode: static` — no JavaScript hydration by default
- Adding a `@client` component for a single toggle would require code generation and JS payload
- The solution must work without JavaScript
- Animation and accessibility (cursor, aria-label) should be preserved

## Considered Options

- CSS-only checkbox hack (hidden `<input type="checkbox">` + `<label>` + `:checked` sibling selector)
- Jaspr `StatefulComponent` with `@client` annotation (JavaScript)
- Inline `<script>` tag with `onclick` toggle

## Decision Outcome

Chosen option: **CSS-only checkbox hack**, because it requires zero JavaScript, works perfectly with Jaspr's static output, and is fully supported in all modern browsers.

### Consequences

- Good, because no JavaScript payload — works even with JS disabled
- Good, because no code generation step or `@client` annotation needed
- Good, because CSS transitions (hamburger → X animation) work natively
- Bad, because the checkbox must be a sibling of the mobile menu in the DOM, which constrains the HTML structure slightly
- Bad, because the menu does not auto-close when a nav link is tapped (anchor links reload the page in static mode, so this is acceptable)

### Confirmation

The hamburger button renders at `≤768px` and the `<input type="checkbox">` controls visibility of `.navbar-mobile-menu` via the CSS `:checked` sibling combinator (`~`).
