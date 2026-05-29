---
parent: Decisions
nav_order: 2
title: "ADR-002: Repository pattern for data access"
status: accepted
date: 2026-05-28
decision-makers: Koen Van Looveren
---

# Repository pattern for data access

## Context and Problem Statement

The site needs real content (meetups, talks, sponsors, team members) from an external API that is still being developed. How should data access be structured so development can proceed without the real API being ready?

## Decision Drivers

- API Dart package is not yet published
- Site must be buildable and runnable with mock data today
- Switching to the real API later should require minimal code changes
- Components should not be coupled to a specific data source

## Considered Options

- Hardcode mock data directly in components
- Abstract repository interface with mock and real implementations
- Use environment variables to toggle between mock and real data

## Decision Outcome

Chosen option: **Abstract repository interface**, because it keeps all data-access concerns in one place and makes the switch to the real API a one-line change in `main.server.dart`.

### Consequences

- Good, because components are decoupled from the data source
- Good, because swapping mock → real API requires only changing one line in `main.server.dart` and deleting the mock files
- Good, because the abstract interface documents the expected API contract
- Bad, because the mock models are temporary scaffolding that will be deleted when the real package lands
