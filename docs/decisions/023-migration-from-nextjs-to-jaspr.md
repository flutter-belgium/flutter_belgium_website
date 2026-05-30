---
parent: Decisions
nav_order: 23
title: "ADR-023: Migration from Next.js to Jaspr — full Dart stack"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Migration from Next.js to Jaspr — full Dart stack

## Context and Problem Statement

The Flutter Belgium website was previously built with Next.js (React/JavaScript). The Made in Flutter Belgium feature needed to be integrated into the site. This was the opportunity to re-evaluate the technology stack.

## Decision Drivers

- The Flutter Belgium community is a Dart/Flutter community — the website toolchain should reflect that
- Next.js introduced a JavaScript build pipeline that no community member was motivated to maintain
- Jaspr provides static site generation with Dart, enabling the same language across data models, routing, and rendering
- The Made in Flutter Belgium data is already modelled in Dart — sharing models between the data layer and the renderer eliminates a serialisation boundary

## Considered Options

- Keep Next.js and add Made in Flutter Belgium as a new section (TypeScript + JSON)
- Keep Next.js and embed a Jaspr micro-frontend for the made-in section
- Rewrite the full site in Jaspr and remove the Next.js implementation

## Decision Outcome

Chosen option: **Full rewrite in Jaspr, remove the Next.js implementation**, because:

- The existing site was small enough that a rewrite was lower risk than maintaining two stacks
- The entire community can contribute to a Dart codebase; almost none could contribute to a Next.js one
- Jaspr's static site generation matches the deployment model (GitHub Pages) exactly
- Data models, routing, and rendering all share Dart types with no serialisation layer

The Next.js source files have been removed. The Jaspr site is deployed to the same GitHub Pages target via the same CI pipeline.

### Consequences

- Good, because the site is maintained in the community's native language
- Good, because Dart types are shared end-to-end from the API response to the rendered HTML
- Good, because the CI pipeline is simpler — one build step, no npm/node toolchain
- Neutral, because contributors familiar with React/Next.js need to learn Jaspr
- Neutral, because Jaspr is less mature than Next.js — some features (e.g. custom non-HTML routes) require more work
