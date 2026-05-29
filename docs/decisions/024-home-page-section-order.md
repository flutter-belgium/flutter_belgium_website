---
parent: Decisions
nav_order: 24
title: "ADR-024: Home page section order"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Home page section order

## Context and Problem Statement

The home page has many sections. The order in which they appear shapes the story a visitor reads. An arbitrary or historical order can make the page feel disconnected.

## Decision Drivers

- Each section should earn its position by logically following from the one before it
- The page should build trust progressively, not dump everything at once
- The call-to-action (Join) should come after trust is established

## Considered Options

- Alphabetical / arbitrary legacy order
- Community-first order (testimonials near top)
- Narrative order based on cause and effect

## Decision Outcome

Chosen option: **Narrative order**, because each section answers a question raised by the previous one.

Order and rationale:
1. **Hero** — What is Flutter Belgium?
2. **About + app showcase** — What do we build and celebrate?
3. **Next meetup** — When is the next event?
4. **Hosting companies** — Who opens their doors for us?
5. **Past meetups** — What have we done?
6. **Talks** — What did people present?
7. **Sponsors** — Who makes the talks possible?
8. **Team** — Who organises all of this?
9. **Testimonials** — What does the community say?
10. **Join** — Ready to be part of it?
11. **Footer**

### Consequences

- Good, because the page reads as a coherent story rather than a list of components
- Good, because the Join CTA appears after maximum trust has been built
- Neutral, because changing section order in the future requires re-evaluating the narrative
