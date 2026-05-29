---
parent: Decisions
nav_order: 25
title: "ADR-025: Shuffle carousels on every build with adjacent-duplicate prevention"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Shuffle carousels on every build with adjacent-duplicate prevention

## Context and Problem Statement

Infinite-scroll carousels (hosting companies, app showcase, testimonials) always show items in the same order on every page load, which makes the site feel static and gives some items permanent prominence over others.

## Decision Drivers

- Fairness: no company, app, or testimonial should always appear first
- Variety: repeated visitors should see a fresh arrangement
- Visual correctness: the infinite scroll seam (where the list wraps) must not show the same item twice in a row

## Considered Options

- Fixed order as returned by the data source
- Random shuffle per build with no constraints
- Shuffle per build with a circular adjacent-duplicate guard

## Decision Outcome

Chosen option: **Shuffle per build with adjacent-duplicate guard**, implemented in `shuffleNoAdjacentDuplicates()` in `lib/util/shuffle_utils.dart`.

The algorithm shuffles the list and then walks it circularly, fixing any position where `items[i] == items[(i+1) % length]` by swapping the offending element with a safe candidate further in the list. Applied to: hosting companies (each row independently), app showcase, and testimonials.

### Consequences

- Good, because each build produces a different order, keeping the site feeling fresh
- Good, because the infinite-scroll seam is always visually clean
- Good, because the utility is reusable for any future carousel
- Neutral, because the shuffle is deterministic within a single build — all visitors of the same deploy see the same order
