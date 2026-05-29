---
parent: Decisions
nav_order: 16
title: "ADR-016: Past meetups are sorted by date, most recent first"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Past meetups are sorted by date, most recent first

## Context and Problem Statement

The past meetups section shows a grid of meetup cards. The order in which they appear matters for users — they are most interested in recent events. In what order should meetups be presented?

## Decision Drivers

- Most visitors are interested in the most recent events first
- The data source (mock or future API) may not guarantee a sorted order
- Sorting should be consistent regardless of the order data is stored

## Considered Options

- Preserve insertion order from the data source
- Sort ascending by date (oldest first)
- Sort descending by date (most recent first)

## Decision Outcome

Chosen option: **Descending by date (most recent first)**, because visitors want to see the latest events immediately without scrolling.

Sorting is applied in `getPastMeetups()` on the repository layer so all callers get a consistent order regardless of storage order:

```dart
Future<List<Meetup>> getPastMeetups() async {
  final sorted = [..._pastMeetups]..sort((a, b) => b.date.compareTo(a.date));
  return List.unmodifiable(sorted);
}
```

### Consequences

- Good, because the most relevant events are immediately visible
- Good, because the sort is in the repository, not in the UI component — components receive data already in display order
- Neutral, because the real API implementation must also sort consistently, or the repository adapter must sort the response
