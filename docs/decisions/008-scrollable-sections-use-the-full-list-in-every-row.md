---
parent: Decisions
nav_order: 8
title: "ADR-008: Scrollable sections use the full list in every row"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Scrollable sections use the full list in every row

## Context and Problem Statement

The hosting companies section shows two auto-scrolling rows of logos moving in opposite directions. The number of companies in the list is variable. How should companies be distributed across the two rows?

## Decision Drivers

- Both rows must always be populated and scrolling regardless of company count
- The visual effect depends on having content in both rows
- The number of companies may be 1 or many

## Considered Options

- Split companies 50/50 across rows (row 1 gets first half, row 2 gets second half)
- Use all companies in both rows

## Decision Outcome

Chosen option: **Use all companies in both rows**, because it is robust to any list size and both rows are always populated. Each row duplicates the list 20× to ensure seamless infinite scrolling.

The visual variety comes from the rows scrolling in opposite directions, not from showing different companies per row.

### Consequences

- Good, because the layout works correctly with any number of companies including 1
- Good, because no special-case logic is needed for small lists
- Neutral, because both rows show the same set of companies — acceptable since variety comes from scroll direction
