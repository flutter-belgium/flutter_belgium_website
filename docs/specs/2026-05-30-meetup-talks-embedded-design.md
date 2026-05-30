# Meetup Talks Embedded — Design Spec

**Date:** 2026-05-30  
**Branch:** feat/meetups-and-talks

---

## Overview

Refactor the meetup/talk relationship so that a `Meetup` directly owns its list of talks. Talks without a YouTube URL are treated as TBD slots and rendered as placeholder cards. Talk slot numbers cycle 1–20. In the meetup description, resolved `<session-N>` tokens are rendered bold.

---

## Data Model Changes

### `Meetup`

Add a `List<Talk> talks` field.

```dart
class Meetup {
  const Meetup({
    required this.id,
    required this.title,
    required this.date,
    required this.hostCompany,
    required this.location,
    required this.talks,   // NEW
    this.description,
    this.thumbnailUrl,
    this.meetupUrl,
  });

  final List<Talk> talks;
  // ... existing fields
}
```

### `Talk`

Remove the `meetupId` field. It is no longer needed — the meetup owns the list.

```dart
class Talk {
  const Talk({
    required this.id,
    required this.title,
    required this.date,
    this.youtubeUrl,       // null = TBD (not recorded yet)
    required this.speakers,
  });
  // meetupId removed
}
```

A talk with `youtubeUrl == null` represents a confirmed talk that has not been recorded/published yet (TBD).

---

## Repository Changes

### `FlutterBelgiumRepository`

- Remove `getTalksByMeetupId(String meetupId)`.
- `getAllTalks()` now traverses all meetups and collects their talks (flattened, sorted by date descending).

### `MockFlutterBelgiumRepository`

- Talks are moved inline into each `Meetup` constructor call.
- `_talks` static list removed.
- `getTalksByMeetupId` implementation removed.

---

## Description Resolver

`MeetupDetailPage._resolveDescription()` replaces `<session-N>` tokens with bold HTML.

- If a talk exists at index N−1: replace with `<b>Title — Speaker1 & Speaker2</b>`
- If no talk at index N−1: replace with `<b>TBD</b>`

The resolver iterates talks from `meetup.talks` (already embedded on the meetup).

---

## UI Changes

### Meetup Detail — Talks Grid (`_MeetupDetailTalks`)

- Shows **all** talks from `meetup.talks`, regardless of whether they have a YouTube URL.
- Each slot is numbered, cycling 1–20: `slotNumber = (index % 20) + 1`.
- Talk with `youtubeUrl != null` → renders `TalkCard` (thumbnail + link, as today).
- Talk with `youtubeUrl == null` → renders `TbdTalkCard` (placeholder card, bold "TBD" label).
- Section is shown if `meetup.talks.isNotEmpty` (previously only shown for talks with video).

### `TalkCard`

No changes to the card itself. Bold talk title/speaker text is **only** in the description resolver — not on the card.

### New: `TbdTalkCard`

A new component rendered for talks without a YouTube URL.

- Displays a styled placeholder (no image, no link).
- Shows the slot number.
- Shows bold **"TBD"** as the only label — no talk title or speaker is shown on the card (the description text already surfaces that context).

### Global Talks Page / Section (`TalksPage`, `TalksSection`)

- Filter to only talks with `youtubeUrl != null` (same intent as today, but now sourced from meetup.talks).
- Slot numbers cycle 1–20 across the displayed list (global index, not per-meetup).

---

## Talk Slot Numbering

Slot number = `(index % 20) + 1`, where `index` is the 0-based position in the displayed list.

- Per-meetup detail page: index resets per meetup.
- Global talks page/section: index is global across displayed talks.

---

## Affected Files

| File | Change |
|------|--------|
| `lib/data/models/meetup.dart` | Add `List<Talk> talks` |
| `lib/data/models/talk.dart` | Remove `meetupId` |
| `lib/data/repositories/flutter_belgium_repository.dart` | Remove `getTalksByMeetupId` |
| `lib/data/repositories/mock_flutter_belgium_repository.dart` | Inline talks into meetups, remove `_talks` list |
| `lib/pages/meetups/meetup_detail_page.dart` | Update resolver + `_MeetupDetailTalks` |
| `lib/components/talk_card.dart` | Minor (accept slot number if needed) |
| `lib/components/talks_section.dart` | Source talks from meetups |
| `lib/pages/talks/talks_page.dart` | Source talks from meetups |
| `lib/main.server.dart` | Remove `getTalksByMeetupId` call if present |
| `lib/pages/home_page.dart` | Update talks sourcing |
| `test/**` | Update tests for new model shape |

---

## Out of Scope

- Adding a UI form to manage talks.
- Pagination of talks.
- Talk detail pages.
