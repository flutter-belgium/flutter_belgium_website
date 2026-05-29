---
parent: Decisions
nav_order: 15
title: "ADR-015: Talk model stores YouTube URL only"
status: accepted
date: 2026-05-29
decision-makers: Koen Van Looveren
---

# Talk model stores YouTube URL only

## Context and Problem Statement

The talks section displays recorded meetup talks as clickable thumbnail cards. Each card links to YouTube and shows the video thumbnail. How much metadata should the `Talk` model carry?

## Decision Drivers

- The only data currently displayed is the video thumbnail (derived from the URL) and the link to YouTube
- Title, speaker, and meetup association are not shown in the current UI
- Storing fields that are not displayed creates maintenance burden with no user value
- The YouTube thumbnail URL is always deterministically derivable from the video ID

## Considered Options

- Full model: `id`, `title`, `speaker`, `meetupId`, `meetupTitle`, `youtubeUrl`, `thumbnailUrl`
- Minimal model: `youtubeUrl` only, with `thumbnailUrl` as a computed getter

## Decision Outcome

Chosen option: **`youtubeUrl` only**, because the UI needs nothing else. `thumbnailUrl` is derived automatically:

```dart
class Talk {
  const Talk({required this.youtubeUrl});
  final String youtubeUrl;

  String get thumbnailUrl {
    final videoId = Uri.tryParse(youtubeUrl)?.queryParameters['v'];
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
```

### Consequences

- Good, because adding a talk requires only a YouTube URL — no metadata to look up or maintain
- Good, because the thumbnail is always in sync with the video — no stale asset URLs
- Good, because the model is the minimum required for the current UI
- Neutral, because adding title/speaker display in future requires extending the model
