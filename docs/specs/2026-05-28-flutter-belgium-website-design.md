# Flutter Belgium Website — Design Spec

**Date:** 2026-05-28
**Status:** Approved

---

## Overview

A static website for Flutter Belgium, the Belgian Flutter community. Built with Jaspr (Dart web framework), hosted on GitHub Pages at `flutterbelgium.be`. The site is a single scrollable homepage showcasing the community, upcoming and past meetups, recorded talks, and links to join Slack and YouTube.

Content is fetched from an external API (a Dart package being developed separately). A mock implementation is used until that package is available. A `repository_dispatch` webhook allows the API to trigger a site rebuild whenever content changes.

---

## Architecture

### Repository Pattern

An abstract class `FlutterBelgiumRepository` defines the data interface. The mock implementation (`MockFlutterBelgiumRepository`) provides hardcoded Dart objects. When the real API package is ready, a new `ApiFlutterBelgiumRepository` is added and wired in `main.dart` — one line change.

```dart
abstract class FlutterBelgiumRepository {
  Future<Meetup?> getNextMeetup();
  Future<List<Meetup>> getPastMeetups();
  Future<List<Talk>> getAllTalks();
  Future<CommunityLinks> getCommunityLinks();
}
```

### Static Site Generation

Jaspr runs in SSG mode. The repository is called at build time; no API calls happen in the browser. The output is fully static HTML/CSS/JS deployed to GitHub Pages.

---

## File Structure

```
lib/
  main.dart                                    # entry point, wires up repository
  app.dart                                     # root Jaspr component
  data/
    models/
      meetup.dart
      talk.dart
      speaker.dart
      community_links.dart
    repositories/
      flutter_belgium_repository.dart          # abstract interface
      mock_flutter_belgium_repository.dart     # hardcoded mock data
  components/
    nav_bar.dart
    hero_section.dart
    about_section.dart
    next_meetup_section.dart
    past_meetups_section.dart
    talks_section.dart
    join_section.dart
    footer.dart
  theme/
    colors.dart                                # brand color constants
    typography.dart                            # font + text style constants
web/
  index.html                                   # loads Google Sans Flex via Google Fonts CDN
.github/
  workflows/
    deploy.yml                                 # build SSG + deploy to gh-pages branch
pubspec.yaml
README.md
```

---

## Data Models

> **Note:** These models are temporary scaffolding. Once the API Dart package is available, its exported types replace these entirely.

```dart
class Meetup {
  final String id;
  final String title;
  final DateTime date;
  final String hostCompany;
  final String location;
  final String? description;
}

class Talk {
  final String id;
  final String title;
  final Speaker speaker;
  final String meetupId;
  final String meetupTitle;   // denormalized for display without extra lookup
  final String? youtubeUrl;
}

class Speaker {
  final String name;
  final String? jobTitle;
  final String? company;
  final String? avatarUrl;
}

class CommunityLinks {
  final String slackInviteUrl;       // https://join.slack.com/t/flutter-belgium/...
  final String youtubeChannelUrl;    // https://www.youtube.com/@flutter-belgium
  final String meetupUrl;            // https://www.meetup.com/flutter-belgium/
  final String linkedinUrl;          // https://www.linkedin.com/company/flutter-belgium/
  final String githubUrl;            // https://github.com/flutter-belgium
  final String madeInUrl;            // https://madein.flutterbelgium.be
}
```

---

## Visual Design

### Brand

| Token | Value |
|-------|-------|
| Navy Dark | `#021F40` |
| Sky | `#027DFD` |
| Yellow | `#FFD648` |
| Red | `#F25D50` |
| Grey | `#E6EDFF` |
| White | `#FFFFFF` |
| Font | Google Sans Flex |

### Section Layout

| # | Section | Background | Notes |
|---|---------|------------|-------|
| 1 | NavBar | White, sticky | Horizontal logo + anchor links to sections |
| 2 | Hero | Grey `#E6EDFF` | Stacked logo, tagline, Slack CTA button |
| 3 | About | White | Short blurb about the community |
| 4 | Next Meetup | Navy `#021F40` | Date, host company, location. Graceful fallback when no upcoming meetup |
| 5 | Past Meetups | Grey `#E6EDFF` | Cards: date, host company, location |
| 6 | Past Talks | White | Cards: title, speaker, YouTube link, meetup badge in Sky `#027DFD` |
| 7 | Join the Community | Sky `#027DFD` | All 6 social links: Slack, YouTube, Meetup, LinkedIn, GitHub, Made in Flutter Belgium |
| 8 | Footer | Navy `#021F40` | Logo, copyright, social icon links |

Yellow `#FFD648` and Red `#F25D50` are used as decorative accents matching the logomark.

---

## Deployment

### GitHub Actions (`deploy.yml`)

Triggers:
- `push` to `main` (code changes)
- `repository_dispatch` with `event_type: content-updated` (content changes from API)

Steps:
1. Checkout repository
2. Setup Dart SDK
3. `dart pub get`
4. `dart run jaspr build`
5. Deploy `build/jaspr` to `gh-pages` branch via `peaceiris/actions-gh-pages`

### Custom Domain

Configure `flutterbelgium.be` once in the repository's GitHub Pages settings. No CNAME file is used.

---

## Triggering a Rebuild

When content changes in the API, send a `repository_dispatch` event to kick off a new build:

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_GITHUB_PAT" \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/flutter-belgium/flutter-belgium-website/dispatches \
  -d '{"event_type":"content-updated"}'
```

**Required token:** A fine-grained GitHub personal access token scoped to this repository with **Actions: write** permission.

---

## Swapping Mock → Real API

When the API Dart package is published:

1. Add the package to `pubspec.yaml`
2. In `main.dart`, replace:
   ```dart
   final repository = MockFlutterBelgiumRepository();
   ```
   with:
   ```dart
   final repository = ApiFlutterBelgiumRepository();
   ```
3. Delete `lib/data/models/` and `lib/data/repositories/mock_flutter_belgium_repository.dart` — the package provides the types and implementation.

---

## Out of Scope

- Multi-page routing (single scrollable page only)
- Pagination (community is small enough for full data in one response)
- Dark mode toggle
- CMS or admin interface
- Comments or user interaction
