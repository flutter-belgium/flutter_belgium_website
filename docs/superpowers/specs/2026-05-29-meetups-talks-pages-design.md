# Meetups & Talks Pages — Design Spec

**Status:** Approved  
**Date:** 2026-05-29

## Overview

Add dedicated meetup list pages, a meetup detail page, and a talk list page to the Flutter Belgium website. These pages replace the current home-page-only presentation of meetups and talks, enabling proper SEO indexing and giving the community a canonical place to find all content.

## Goals

- SEO-friendly, statically generated pages for meetups and talks
- Meetup detail page with sign-up button (upcoming) and related talks
- Talk list page where clicks go to YouTube directly
- Home page sections become teasers linking to the full pages
- Unified `Person` model usable across talks (speakers), testimonials, and Made In Flutter Belgium developer cross-references

---

## Data Models

### `PersonSocialLinks`

```dart
githubUrl: String?
linkedinUrl: String?
twitterUrl: String?
websiteUrl: String?
```

### `PersonCompany`

```dart
name: String
jobTitle: String
isActive: bool
```

### `Person`

Replaces the unused `Speaker` model. Used for talk speakers, testimonial authors, and cross-referenced to `MadeInDeveloper` via GitHub username.

```dart
id: String
name: String
avatarUrl: String
companies: List<PersonCompany>   // supports freelancers with multiple active clients
githubUsername: String?          // nullable; used to match MadeInDeveloper at build time
socialLinks: PersonSocialLinks
```

**Computed getter:**
```dart
PersonCompany? get activeCompany => companies.firstWhereOrNull((c) => c.isActive)
```

`activeCompany` is used wherever a single job title + company name is needed (testimonials, speaker cards).

### `Talk` (extended)

```dart
id: String
title: String
date: DateTime
youtubeUrl: String?              // nullable — video may not be published yet
meetupId: String                 // links to Meetup.id
speakers: List<Person>
```

**Computed getter (existing, now nullable):**
```dart
String? get thumbnailUrl  // derived from youtubeUrl; null when youtubeUrl is null
```

### `Meetup` (unchanged model, new computed field)

Existing fields: `id`, `title`, `date`, `hostCompany`, `location`, `description`, `thumbnailUrl`, `meetupUrl`.

**New computed getter:**
```dart
String get slug  // slugified from title, e.g. "flutter-belgium-meetup-22"
```

Slug uses the same slugify utility as the Made In Flutter Belgium pages.

### `Testimonial` (updated)

```dart
text: String
author: Person    // replaces authorName, authorRole, authorAvatarUrl
```

The display name, avatar, job title, and company are read from `author` and `author.activeCompany`.

### Deleted models

- `Speaker` — fully replaced by `Person`

---

## Repository

New methods added to `FlutterBelgiumRepository`:

```dart
Future<List<Person>> getPersons();
Future<Meetup?> getMeetupBySlug(String slug);
Future<List<Talk>> getTalksByMeetupId(String meetupId);
Future<List<Talk>> getAllTalks();   // sorted newest first by date
```

`MockFlutterBelgiumRepository` is updated with rich mock data: persons with `PersonCompany` entries, talks linked to meetups via `meetupId`, and testimonials referencing persons.

### Build-time cross-reference

In `main.server.dart`, after fetching persons and Made In developers, match `Person.githubUsername == MadeInDeveloper.githubUsername`. The matched Made In apps are passed to components that render speaker cards so a "Made In" badge can be shown where a match exists.

---

## Pages & Routing

Four new routes added to `main.server.dart`:

| Route | Page component | Notes |
|---|---|---|
| `/meetups/upcoming` | `MeetupsUpcomingPage` | Static route — takes priority over `:slug` |
| `/meetups/past` | `MeetupsPastPage` | Static route — takes priority over `:slug` |
| `/meetups/:slug` | `MeetupDetailPage` | Dynamic; slug resolved via `getMeetupBySlug` |
| `/talks` | `TalksPage` | All talks with YouTube URL, sorted newest first |

### `/meetups/upcoming` and `/meetups/past`

- Same tab UI as Made In Flutter Belgium list pages
- Cards use the same grid + card style as the existing `PastMeetupsSection` on the home page (thumbnail top, date/title/host below, fully clickable)
- Upcoming: meetups where `date >= today`, ascending order
- Past: meetups where `date < today`, descending order
- Cards link to `/meetups/:slug` (not to Meetup.com directly)

### `/meetups/:slug` — Meetup Detail

Two sections, matching home page visual patterns:

**Section 1 — Hero (dark navy, same style as `NextMeetupSection`):**
- Meta line: date · location · host company
- Meetup title
- Thumbnail image
- Description
- "Sign up for this event" button (pill, outline-white style) — only rendered when `meetup.date >= today` and `meetup.meetupUrl != null`; links to `meetup.meetupUrl`

**Section 2 — Talks (light bg, same style as `TalksSection`):**
- Section label "Talks" + heading "Catch up on what you missed"
- Same thumbnail grid as `TalksSection`
- Cards with YouTube URL: thumbnail + title + speaker avatars, click opens YouTube
- Cards without YouTube URL: grey placeholder with "Video coming soon", not clickable
- Talks fetched via `getTalksByMeetupId(meetup.id)`

### `/talks` — Talk List

- Same visual as home `TalksSection`: thumbnail-only cards, click opens YouTube in new tab
- Only talks with a `youtubeUrl` are shown
- All talks shown (not limited), sorted newest first
- Section label + heading identical to home section

---

## Home Page Changes

| Section | Change |
|---|---|
| `NextMeetupSection` | Add "View all upcoming →" link below CTA, pointing to `/meetups/upcoming` |
| `PastMeetupsSection` | Show only 3 most recent past meetups; add "View all meetups →" link pointing to `/meetups/past` |
| `TalksSection` | Show only 3 most recent talks; add "View all talks →" link pointing to `/talks` |

---

## Error Handling

- `/meetups/:slug` with unknown slug: render a 404-style "Meetup not found" message (same pattern as Made In detail pages)
- Meetup with no talks yet: talks section is hidden entirely on the detail page
- Upcoming meetup with no `meetupUrl`: sign-up button is hidden

---

## Testing

- Unit tests for `Person`, `PersonCompany`, `PersonSocialLinks`, updated `Talk`, updated `Testimonial` models
- Unit tests for updated `MockFlutterBelgiumRepository` (new methods)
- Component tests for `MeetupsUpcomingPage`, `MeetupsPastPage`, `MeetupDetailPage`, `TalksPage`
- Component tests for updated home sections (teaser limits + "View all" links)
- Component tests for updated `TestimonialsSection` (person-based author)
