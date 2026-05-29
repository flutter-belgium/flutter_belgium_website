---
parent: Decisions
nav_order: 1
title: "ADR-001: Jaspr for static site generation"
status: accepted
date: 2026-05-28
decision-makers: Koen Van Looveren
---

# Jaspr for static site generation

## Context and Problem Statement

The Flutter Belgium website needs to be a public-facing site that is fast, SEO-friendly, and easy to maintain. The team is primarily Flutter/Dart developers. What framework should be used to build and deploy the site?

## Decision Drivers

- Team is fluent in Dart, not in JavaScript/TypeScript frameworks
- Site is content-focused and does not need client-side interactivity
- Must be SEO-friendly (server-rendered HTML)
- Should be cheap to host (no server runtime required)

## Considered Options

- Jaspr (Dart SSG/SSR web framework)
- Next.js (React-based, requires JS knowledge)
- Flutter Web (client-side only, poor SEO)
- Plain HTML/CSS

## Decision Outcome

Chosen option: **Jaspr in static mode**, because it allows the team to write Dart throughout, produces fully static HTML/CSS output deployable to GitHub Pages at zero cost, and is SEO-friendly by default.

### Consequences

- Good, because the entire codebase is Dart — no context switching
- Good, because output is static HTML, hosting on GitHub Pages is free
- Good, because Jaspr components are structurally similar to Flutter widgets, lowering the learning curve
- Bad, because Jaspr is a smaller ecosystem than React/Next.js with fewer community resources
- Bad, because client-side interactivity requires either CSS tricks or the `@client` annotation with code generation
