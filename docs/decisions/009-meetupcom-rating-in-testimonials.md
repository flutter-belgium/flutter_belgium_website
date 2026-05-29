---
parent: Decisions
nav_order: 9
title: "ADR-009: Meetup.com rating badge in testimonials section"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Meetup.com rating badge in testimonials section

## Context and Problem Statement

Flutter Belgium has a 4.7/5 rating with 128 reviews on Meetup.com. This is strong social proof that should be visible on the website. Where should it be placed and how should it be presented?

## Decision Drivers

- The rating reinforces the community testimonials already shown on the page
- It should link back to Meetup.com so visitors can verify
- Placement should feel natural and not interrupt the page flow

## Considered Options

- Add as a standalone section between Join and Sponsors
- Embed in the hero section alongside the tagline
- Place in the testimonials section header, aligned top-right of the title

## Decision Outcome

Chosen option: **Top-right of the testimonials section header**, because it sits alongside the "What Flutter Belgium members say" heading and reinforces the same message. The pill-shaped badge links to the Meetup.com group page and is visually unobtrusive.

### Consequences

- Good, because placement is contextually relevant — rating and testimonials reinforce each other
- Good, because the badge is a native link, no JavaScript required
- Neutral, because the rating (4.7, 128 reviews) is hardcoded and must be updated manually when it changes
