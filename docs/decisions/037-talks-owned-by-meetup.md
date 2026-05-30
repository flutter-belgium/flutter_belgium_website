---
parent: Decisions
nav_order: 37
title: "ADR-037: Talks owned directly by Meetup"
status: accepted
date: 2026-05-30
decision-makers: Koen Van Looveren
---

# Talks owned directly by Meetup

## Context and Problem Statement

The original data model stored talks in a flat list with a `meetupId` foreign key on each `Talk`. The repository exposed a `getTalksByMeetupId(String meetupId)` method to fetch the talks for a given meetup. This mirrored a relational database pattern but added indirection: callers had to perform a secondary lookup to associate talks with their meetup, and `main.server.dart` had to filter talks by `meetupId` when building meetup detail routes.

## Decision Drivers

- A meetup is the natural owner of its talks — talks do not exist independently of a meetup
- The flat-list-plus-foreign-key pattern required callers to join two separate collections
- Embedding talks on `Meetup` eliminates the `getTalksByMeetupId` method and the filter logic in the server entry point
- The site is statically generated; there is no query cost advantage to normalising the data

## Considered Options

- Keep flat list with `meetupId` foreign key and `getTalksByMeetupId` repository method
- Embed `List<Talk>` directly on `Meetup`; derive `getAllTalks()` by traversing meetups

## Decision Outcome

Chosen option: **`List<Talk> talks` embedded on `Meetup`** with a default of `const []`.

`Talk.meetupId` was removed. `FlutterBelgiumRepository.getTalksByMeetupId` was removed. `getAllTalks()` now traverses all meetups and flattens their talk lists. `MeetupDetailPage` no longer receives a separate `talks` parameter — it reads `meetup.talks` directly.

### Consequences

- Good, because the data structure reflects ownership: a meetup contains its talks
- Good, because no join logic is needed at the call site
- Good, because `MeetupDetailPage` is simpler — one parameter fewer
- Neutral, because `getAllTalks()` must traverse meetups rather than a flat list (negligible at this scale)
