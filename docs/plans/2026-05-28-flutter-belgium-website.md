# Flutter Belgium Website — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a static Jaspr website for the Flutter Belgium community, deployed via GitHub Actions to GitHub Pages at flutterbelgium.be.

**Architecture:** Single scrollable homepage. All data fetched at build time from `MockFlutterBelgiumRepository` implementing `FlutterBelgiumRepository`. Jaspr SSG pre-renders static HTML. GitHub Actions deploys on `push` to `main` or `repository_dispatch` with type `content-updated`.

**Tech Stack:** Dart 3.3+, Jaspr 0.18+, jaspr_test, GitHub Actions, GitHub Pages

> Commits are handled by the developer — never run `git commit` or `git push`.

---

## File Map

```
lib/
  main.dart
  app.dart
  data/
    models/
      meetup.dart
      talk.dart
      speaker.dart
      community_links.dart
    repositories/
      flutter_belgium_repository.dart
      mock_flutter_belgium_repository.dart
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
    colors.dart
test/
  data/
    models/models_test.dart
    repositories/mock_repository_test.dart
  components/
    nav_bar_test.dart
    next_meetup_section_test.dart
    past_meetups_section_test.dart
    talks_section_test.dart
web/
  index.html
  styles.css
  assets/
    logo-stacked.svg       ← obtain from brand assets
    logo-horizontal.svg    ← obtain from brand assets
    logomark.svg           ← obtain from brand assets
.github/
  workflows/
    deploy.yml
pubspec.yaml
README.md
```

---

### Task 1: Project setup

**Files:**

- Create: `pubspec.yaml`

- [ ] Create `pubspec.yaml`:

```yaml
name: flutter_belgium_website
description: Flutter Belgium community website — flutterbelgium.be

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  jaspr: ^0.18.0

dev_dependencies:
  build_runner: ^2.4.0
  jaspr_builder: ^0.18.0
  jaspr_test: ^0.18.0
  test: ^1.24.0
```

- [ ] Fetch dependencies:

```bash
dart pub get
```

Expected: resolves without errors.

- [ ] Verify jaspr CLI works:

```bash
dart run jaspr --version
```

Expected: prints a version number. If this fails, check the [Jaspr docs](https://docs.page/schultek/jaspr) for the correct invocation for your installed version — the command may differ between minor versions.

---

### Task 2: Theme constants

**Files:**

- Create: `lib/theme/colors.dart`

- [ ] Create `lib/theme/colors.dart`:

```dart
abstract final class AppColors {
  static const String navy = '#021F40';
  static const String sky = '#027DFD';
  static const String yellow = '#FFD648';
  static const String red = '#F25D50';
  static const String grey = '#E6EDFF';
  static const String white = '#FFFFFF';
}
```

These values are brand constants referenced in CSS class names and may be used for dynamic styles. CSS custom properties defined in Task 6 (`styles.css`) are the primary styling mechanism.

---

### Task 3: Data models

**Files:**

- Create: `lib/data/models/speaker.dart`
- Create: `lib/data/models/meetup.dart`
- Create: `lib/data/models/talk.dart`
- Create: `lib/data/models/community_links.dart`
- Create: `test/data/models/models_test.dart`

> These models are temporary scaffolding. When the API Dart package is published, delete `lib/data/models/` entirely and use the package's exported types.

- [ ] Write failing test at `test/data/models/models_test.dart`:

```dart
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/speaker.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:test/test.dart';

void main() {
  group('Meetup', () {
    test('constructs with required fields, description defaults to null', () {
      final meetup = Meetup(
        id: '1',
        title: 'Flutter Belgium #1',
        date: DateTime(2024, 3, 14),
        hostCompany: 'iO',
        location: 'Ghent',
      );
      expect(meetup.id, '1');
      expect(meetup.description, isNull);
    });
  });

  group('Talk', () {
    test('constructs with required fields, youtubeUrl defaults to null', () {
      final talk = Talk(
        id: 't1',
        title: 'Building with Flutter',
        speaker: const Speaker(name: 'Jane Doe'),
        meetupId: '1',
        meetupTitle: 'Flutter Belgium #1',
      );
      expect(talk.youtubeUrl, isNull);
      expect(talk.meetupTitle, 'Flutter Belgium #1');
    });
  });

  group('CommunityLinks', () {
    test('constructs correctly', () {
      const links = CommunityLinks(
        slackInviteUrl: 'https://slack.com/invite/xxx',
        youtubeChannelUrl: 'https://youtube.com/@flutter-belgium',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/',
        linkedinUrl: 'https://www.linkedin.com/company/flutter-belgium/',
        githubUrl: 'https://github.com/flutter-belgium',
        madeInUrl: 'https://madein.flutterbelgium.be',
      );
      expect(links.slackInviteUrl, startsWith('https://'));
      expect(links.meetupUrl, startsWith('https://'));
    });
  });
}
```

- [ ] Run to verify it fails:

```bash
dart test test/data/models/models_test.dart
```

Expected: error — files not found.

- [ ] Create `lib/data/models/speaker.dart`:

```dart
class Speaker {
  const Speaker({
    required this.name,
    this.jobTitle,
    this.company,
    this.avatarUrl,
  });

  final String name;
  final String? jobTitle;
  final String? company;
  final String? avatarUrl;
}
```

- [ ] Create `lib/data/models/meetup.dart`:

```dart
class Meetup {
  const Meetup({
    required this.id,
    required this.title,
    required this.date,
    required this.hostCompany,
    required this.location,
    this.description,
  });

  final String id;
  final String title;
  final DateTime date;
  final String hostCompany;
  final String location;
  final String? description;
}
```

- [ ] Create `lib/data/models/talk.dart`:

```dart
import 'speaker.dart';

class Talk {
  const Talk({
    required this.id,
    required this.title,
    required this.speaker,
    required this.meetupId,
    required this.meetupTitle,
    this.youtubeUrl,
  });

  final String id;
  final String title;
  final Speaker speaker;
  final String meetupId;
  final String meetupTitle;
  final String? youtubeUrl;
}
```

- [ ] Create `lib/data/models/community_links.dart`:

```dart
class CommunityLinks {
  const CommunityLinks({
    required this.slackInviteUrl,
    required this.youtubeChannelUrl,
    required this.meetupUrl,
    required this.linkedinUrl,
    required this.githubUrl,
    required this.madeInUrl,
  });

  final String slackInviteUrl;
  final String youtubeChannelUrl;
  final String meetupUrl;
  final String linkedinUrl;
  final String githubUrl;
  final String madeInUrl;
}
```

- [ ] Run test to verify it passes:

```bash
dart test test/data/models/models_test.dart
```

Expected: 3 tests PASS.

---

### Task 4: Repository interface and mock

**Files:**

- Create: `lib/data/repositories/flutter_belgium_repository.dart`
- Create: `lib/data/repositories/mock_flutter_belgium_repository.dart`
- Create: `test/data/repositories/mock_repository_test.dart`

- [ ] Write failing test at `test/data/repositories/mock_repository_test.dart`:

```dart
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/repositories/mock_flutter_belgium_repository.dart';
import 'package:test/test.dart';

void main() {
  late MockFlutterBelgiumRepository repo;

  setUp(() => repo = MockFlutterBelgiumRepository());

  test('getNextMeetup returns a Meetup with non-empty fields', () async {
    final meetup = await repo.getNextMeetup();
    if (meetup != null) {
      expect(meetup.id, isNotEmpty);
      expect(meetup.hostCompany, isNotEmpty);
    }
  });

  test('getPastMeetups returns a non-empty list of Meetup', () async {
    final meetups = await repo.getPastMeetups();
    expect(meetups, isA<List<Meetup>>());
    expect(meetups, isNotEmpty);
  });

  test('getAllTalks returns talks with meetupTitle set', () async {
    final talks = await repo.getAllTalks();
    expect(talks, isA<List<Talk>>());
    expect(talks, isNotEmpty);
    for (final talk in talks) {
      expect(talk.meetupTitle, isNotEmpty);
    }
  });

  test('getCommunityLinks returns https URLs for all links', () async {
    final links = await repo.getCommunityLinks();
    expect(links, isA<CommunityLinks>());
    expect(links.slackInviteUrl, startsWith('https://'));
    expect(links.youtubeChannelUrl, startsWith('https://'));
    expect(links.meetupUrl, startsWith('https://'));
    expect(links.linkedinUrl, startsWith('https://'));
    expect(links.githubUrl, startsWith('https://'));
    expect(links.madeInUrl, startsWith('https://'));
  });
}
```

- [ ] Run to verify it fails:

```bash
dart test test/data/repositories/mock_repository_test.dart
```

Expected: error — files not found.

- [ ] Create `lib/data/repositories/flutter_belgium_repository.dart`:

```dart
import '../models/community_links.dart';
import '../models/meetup.dart';
import '../models/talk.dart';

abstract class FlutterBelgiumRepository {
  Future<Meetup?> getNextMeetup();
  Future<List<Meetup>> getPastMeetups();
  Future<List<Talk>> getAllTalks();
  Future<CommunityLinks> getCommunityLinks();
}
```

- [ ] Create `lib/data/repositories/mock_flutter_belgium_repository.dart`:

```dart
import '../models/community_links.dart';
import '../models/meetup.dart';
import '../models/speaker.dart';
import '../models/talk.dart';
import 'flutter_belgium_repository.dart';

class MockFlutterBelgiumRepository implements FlutterBelgiumRepository {
  static final List<Meetup> _pastMeetups = [
    Meetup(
      id: 'meetup-1',
      title: 'Flutter Belgium #1',
      date: DateTime(2023, 11, 16),
      hostCompany: 'iO',
      location: 'Ghent',
      description: 'Our first Flutter Belgium meetup, hosted by iO in Ghent.',
    ),
    Meetup(
      id: 'meetup-2',
      title: 'Flutter Belgium #2',
      date: DateTime(2024, 2, 22),
      hostCompany: 'Zimmo',
      location: 'Antwerp',
      description: 'Flutter Belgium returns at Zimmo in Antwerp.',
    ),
    Meetup(
      id: 'meetup-3',
      title: 'Flutter Belgium #3',
      date: DateTime(2024, 5, 30),
      hostCompany: 'Cegeka',
      location: 'Hasselt',
      description: 'Advanced Flutter topics, hosted by Cegeka in Hasselt.',
    ),
  ];

  static final List<Talk> _talks = [
    Talk(
      id: 'talk-1',
      title: 'Getting Started with Flutter',
      speaker: const Speaker(name: 'Jan Peeters', jobTitle: 'Flutter Developer', company: 'iO'),
      meetupId: 'meetup-1',
      meetupTitle: 'Flutter Belgium #1',
      youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    Talk(
      id: 'talk-2',
      title: 'State Management in 2024',
      speaker: const Speaker(name: 'Lisa Maes', jobTitle: 'Senior Developer', company: 'Zimmo'),
      meetupId: 'meetup-2',
      meetupTitle: 'Flutter Belgium #2',
      youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    Talk(
      id: 'talk-3',
      title: 'Flutter Web in Production',
      speaker: const Speaker(name: 'Tom Claes', jobTitle: 'Lead Engineer', company: 'Cegeka'),
      meetupId: 'meetup-3',
      meetupTitle: 'Flutter Belgium #3',
      youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    Talk(
      id: 'talk-4',
      title: 'Custom Painters Deep Dive',
      speaker: const Speaker(name: 'An Willems', company: 'Freelance'),
      meetupId: 'meetup-3',
      meetupTitle: 'Flutter Belgium #3',
    ),
  ];

  @override
  Future<Meetup?> getNextMeetup() async => Meetup(
        id: 'meetup-next',
        title: 'Flutter Belgium #4',
        date: DateTime(2024, 9, 19),
        hostCompany: 'Cronos',
        location: 'Leuven',
        description: 'Join us for our fourth meetup, hosted by Cronos in Leuven.',
      );

  @override
  Future<List<Meetup>> getPastMeetups() async => _pastMeetups;

  @override
  Future<List<Talk>> getAllTalks() async => _talks;

  @override
  Future<CommunityLinks> getCommunityLinks() async => const CommunityLinks(
        slackInviteUrl: 'https://join.slack.com/t/flutter-belgium/shared_invite/zt-2w7m73ron-5NZWiebmvxXAzBairbAisw',
        youtubeChannelUrl: 'https://www.youtube.com/@flutter-belgium',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/',
        linkedinUrl: 'https://www.linkedin.com/company/flutter-belgium/',
        githubUrl: 'https://github.com/flutter-belgium',
        madeInUrl: 'https://madein.flutterbelgium.be',
      );
}
```

- [ ] Run test to verify it passes:

```bash
dart test test/data/repositories/mock_repository_test.dart
```

Expected: 4 tests PASS.

---

### Task 5: HTML shell

**Files:**

- Create: `web/index.html`

The `web/index.html` is Jaspr's build template. It provides the `<head>` with metadata, fonts, and CSS. Jaspr renders the component tree into the `<body>`.

- [ ] Create `web/index.html`:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <meta
      name="description"
      content="Flutter Belgium — the Belgian Flutter community. Meetups, talks, and a Slack community for Flutter developers in Belgium."
    />
    <title>Flutter Belgium</title>

    <!-- Google Fonts: Google Sans Flex -->
    <!-- Note: verify this URL on fonts.google.com. If Google Sans Flex is unavailable,
         replace with DM Sans which has a near-identical aesthetic:
         https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,100..1000;1,9..40,100..1000&display=swap -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Google+Sans+Flex:ital,opsz,wght@0,12..72,100..900;1,12..72,100..900&display=swap"
      rel="stylesheet"
    />

    <link rel="stylesheet" href="styles.css" />
    <link rel="icon" type="image/svg+xml" href="assets/logomark.svg" />
  </head>
  <body></body>
</html>
```

---

### Task 6: Global CSS

**Files:**

- Create: `web/styles.css`

- [ ] Create `web/styles.css`:

```css
/* ── Variables ─────────────────────────────────────────────────── */
:root {
  --color-navy: #021f40;
  --color-sky: #027dfd;
  --color-yellow: #ffd648;
  --color-red: #f25d50;
  --color-grey: #e6edff;
  --color-white: #ffffff;

  --font-family: "Google Sans Flex", "DM Sans", sans-serif;
  --container-max: 1200px;
  --section-padding: 5rem 1.5rem;
}

/* ── Reset ─────────────────────────────────────────────────────── */
*,
*::before,
*::after {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
img {
  display: block;
  max-width: 100%;
}
a {
  color: inherit;
  text-decoration: none;
}
ul {
  list-style: none;
}

body {
  font-family: var(--font-family);
  color: var(--color-navy);
  background: var(--color-white);
  line-height: 1.6;
}

/* ── Layout ────────────────────────────────────────────────────── */
.container {
  max-width: var(--container-max);
  margin: 0 auto;
  padding: 0 1.5rem;
}

/* ── NavBar ────────────────────────────────────────────────────── */
.navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: var(--color-white);
  border-bottom: 1px solid var(--color-grey);
}

.navbar-inner {
  display: flex;
  align-items: center;
  justify-content: space-between;
  height: 64px;
}

.navbar-logo-img {
  height: 32px;
}

.navbar-links {
  display: flex;
  gap: 2rem;
}

.navbar-link {
  font-size: 0.95rem;
  font-weight: 500;
  color: var(--color-navy);
  transition: color 0.2s;
}

.navbar-link:hover {
  color: var(--color-sky);
}

/* ── Buttons ───────────────────────────────────────────────────── */
.btn {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.75rem 1.75rem;
  border-radius: 8px;
  font-family: var(--font-family);
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition:
    opacity 0.2s,
    transform 0.1s;
  text-decoration: none;
}

.btn:hover {
  opacity: 0.88;
  transform: translateY(-1px);
}

.btn-primary {
  background: var(--color-sky);
  color: var(--color-white);
}

.btn-secondary {
  background: var(--color-white);
  color: var(--color-navy);
}

.btn-outline-white {
  background: transparent;
  color: var(--color-white);
  border: 2px solid var(--color-white);
}

/* ── Hero ──────────────────────────────────────────────────────── */
.hero {
  background: var(--color-grey);
  padding: 6rem 1.5rem;
}

.hero-inner {
  max-width: var(--container-max);
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  gap: 2rem;
}

.hero-logo {
  height: 120px;
}

.hero-tagline {
  font-size: clamp(2rem, 4vw, 3rem);
  font-weight: 700;
  color: var(--color-navy);
  line-height: 1.2;
  max-width: 600px;
}

.hero-sub {
  font-size: 1.125rem;
  color: var(--color-navy);
  opacity: 0.75;
  max-width: 520px;
}

.hero-actions {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}

/* ── About ─────────────────────────────────────────────────────── */
.about {
  background: var(--color-white);
  padding: var(--section-padding);
}

.about-inner {
  max-width: var(--container-max);
  margin: 0 auto;
}

.section-label {
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: var(--color-sky);
  margin-bottom: 1rem;
}

.section-title {
  font-size: clamp(1.75rem, 3vw, 2.5rem);
  font-weight: 700;
  line-height: 1.2;
  margin-bottom: 1.25rem;
}

.section-body {
  font-size: 1.125rem;
  line-height: 1.75;
  max-width: 680px;
  opacity: 0.8;
}

/* ── Next Meetup ───────────────────────────────────────────────── */
.next-meetup {
  background: var(--color-navy);
  color: var(--color-white);
  padding: var(--section-padding);
}

.next-meetup .section-label {
  color: var(--color-yellow);
}

.next-meetup .section-title {
  color: var(--color-white);
}

.next-meetup-inner {
  max-width: var(--container-max);
  margin: 0 auto;
}

.meetup-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 1.5rem;
  margin: 2rem 0;
}

.meetup-meta-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.meetup-meta-label {
  font-size: 0.75rem;
  font-weight: 700;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  opacity: 0.6;
}

.meetup-meta-value {
  font-size: 1.125rem;
  font-weight: 600;
}

.no-meetup-message {
  font-size: 1.125rem;
  opacity: 0.7;
  margin-top: 1rem;
}

/* ── Past Meetups ──────────────────────────────────────────────── */
.past-meetups {
  background: var(--color-grey);
  padding: var(--section-padding);
}

.past-meetups-inner {
  max-width: var(--container-max);
  margin: 0 auto;
}

.meetups-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 1.5rem;
  margin-top: 2.5rem;
}

.meetup-card {
  background: var(--color-white);
  border-radius: 12px;
  padding: 1.75rem;
  box-shadow: 0 2px 8px rgba(2, 31, 64, 0.06);
  transition:
    transform 0.2s,
    box-shadow 0.2s;
}

.meetup-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(2, 31, 64, 0.1);
}

.meetup-card-date {
  font-size: 0.85rem;
  font-weight: 600;
  color: var(--color-sky);
  margin-bottom: 0.5rem;
}

.meetup-card-title {
  font-size: 1.2rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
}

.meetup-card-host {
  font-size: 0.95rem;
  opacity: 0.65;
  margin-bottom: 0.75rem;
}

.meetup-card-description {
  font-size: 0.9rem;
  line-height: 1.6;
  opacity: 0.7;
}

/* ── Talks ─────────────────────────────────────────────────────── */
.talks {
  background: var(--color-white);
  padding: var(--section-padding);
}

.talks-inner {
  max-width: var(--container-max);
  margin: 0 auto;
}

.talks-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
  gap: 1.5rem;
  margin-top: 2.5rem;
}

.talk-card {
  border: 1.5px solid var(--color-grey);
  border-radius: 12px;
  padding: 1.75rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  transition:
    border-color 0.2s,
    box-shadow 0.2s;
}

.talk-card:hover {
  border-color: var(--color-sky);
  box-shadow: 0 4px 16px rgba(2, 125, 253, 0.1);
}

.talk-meetup-badge {
  display: inline-block;
  background: var(--color-sky);
  color: var(--color-white);
  font-size: 0.75rem;
  font-weight: 700;
  padding: 0.25rem 0.65rem;
  border-radius: 99px;
  width: fit-content;
}

.talk-title {
  font-size: 1.1rem;
  font-weight: 700;
  line-height: 1.3;
}

.talk-speaker {
  font-size: 0.9rem;
  opacity: 0.65;
}

.talk-speaker-name {
  font-weight: 600;
}

.talk-link {
  margin-top: auto;
  display: inline-flex;
  align-items: center;
  gap: 0.4rem;
  font-size: 0.9rem;
  font-weight: 600;
  color: var(--color-sky);
}

.talk-link:hover {
  text-decoration: underline;
}

.talk-no-video {
  font-size: 0.85rem;
  opacity: 0.45;
  margin-top: auto;
}

/* ── Join ──────────────────────────────────────────────────────── */
.join {
  background: var(--color-sky);
  color: var(--color-white);
  padding: var(--section-padding);
  text-align: center;
}

.join-inner {
  max-width: 640px;
  margin: 0 auto;
}

.join .section-title {
  color: var(--color-white);
}

.join-sub {
  font-size: 1.125rem;
  opacity: 0.85;
  margin: 1rem 0 2.5rem;
}

.join-actions {
  display: flex;
  justify-content: center;
  gap: 1rem;
  flex-wrap: wrap;
}

/* ── Footer ────────────────────────────────────────────────────── */
.footer {
  background: var(--color-navy);
  color: var(--color-white);
  padding: 3rem 1.5rem;
}

.footer-inner {
  max-width: var(--container-max);
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1.5rem;
}

.footer-logo {
  height: 36px;
  filter: brightness(0) invert(1);
}

.footer-copy {
  font-size: 0.85rem;
  opacity: 0.5;
}

/* ── Responsive ────────────────────────────────────────────────── */
@media (max-width: 768px) {
  .navbar-links {
    display: none;
  } /* mobile nav out of scope for v1 */

  .hero {
    padding: 4rem 1.25rem;
  }
  .hero-logo {
    height: 80px;
  }

  .meetups-grid,
  .talks-grid {
    grid-template-columns: 1fr;
  }

  .footer-inner {
    flex-direction: column;
    align-items: flex-start;
  }
}
```

---

### Task 7: App root and main entry point

**Files:**

- Create: `lib/app.dart`
- Create: `lib/main.dart`

- [ ] Create `lib/app.dart`:

```dart
import 'package:jaspr/jaspr.dart';

import 'components/about_section.dart';
import 'components/footer.dart';
import 'components/hero_section.dart';
import 'components/join_section.dart';
import 'components/nav_bar.dart';
import 'components/next_meetup_section.dart';
import 'components/past_meetups_section.dart';
import 'components/talks_section.dart';
import 'data/models/community_links.dart';
import 'data/models/meetup.dart';
import 'data/models/talk.dart';

class App extends StatelessComponent {
  const App({
    required this.nextMeetup,
    required this.pastMeetups,
    required this.talks,
    required this.communityLinks,
    super.key,
  });

  final Meetup? nextMeetup;
  final List<Meetup> pastMeetups;
  final List<Talk> talks;
  final CommunityLinks communityLinks;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield NavBar();
    yield HeroSection(communityLinks: communityLinks);
    yield AboutSection();
    yield NextMeetupSection(meetup: nextMeetup, communityLinks: communityLinks);
    yield PastMeetupsSection(meetups: pastMeetups);
    yield TalksSection(talks: talks);
    yield JoinSection(communityLinks: communityLinks);
    yield Footer();
  }
}
```

- [ ] Create `lib/main.dart`:

```dart
import 'package:jaspr/server.dart';

import 'app.dart';
import 'data/repositories/mock_flutter_belgium_repository.dart';

// To switch to the real API package, replace MockFlutterBelgiumRepository
// with the ApiFlutterBelgiumRepository from the published Dart package,
// then delete lib/data/models/ and lib/data/repositories/mock_*.dart.
void main() async {
  final repository = MockFlutterBelgiumRepository();

  final nextMeetup = await repository.getNextMeetup();
  final pastMeetups = await repository.getPastMeetups();
  final talks = await repository.getAllTalks();
  final communityLinks = await repository.getCommunityLinks();

  runApp(App(
    nextMeetup: nextMeetup,
    pastMeetups: pastMeetups,
    talks: talks,
    communityLinks: communityLinks,
  ));
}
```

- [ ] Verify the project compiles (no Jaspr components exist yet, so this will fail — expected):

```bash
dart analyze lib/main.dart
```

This will error until the component files are created in Tasks 8–15. That is expected.

---

### Task 8: NavBar component

**Files:**

- Create: `lib/components/nav_bar.dart`
- Create: `test/components/nav_bar_test.dart`

- [ ] Write failing test at `test/components/nav_bar_test.dart`:

```dart
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:jaspr_test/jaspr_test.dart';
import 'package:test/test.dart';

void main() {
  testComponents('NavBar renders logo and nav links', (tester) async {
    await tester.pumpComponent(NavBar());

    expect(find.byTag('header'), findsOneComponent);
    expect(find.text('About'), findsOneComponent);
    expect(find.text('Meetups'), findsOneComponent);
    expect(find.text('Talks'), findsOneComponent);
    expect(find.text('Join'), findsOneComponent);
  });
}
```

- [ ] Run to verify it fails:

```bash
dart test test/components/nav_bar_test.dart
```

Expected: error — file not found.

- [ ] Create `lib/components/nav_bar.dart`:

```dart
import 'package:jaspr/jaspr.dart';

class NavBar extends StatelessComponent {
  const NavBar({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield header(classes: 'navbar', [
      div(classes: 'navbar-inner container', [
        a(href: '/', classes: 'navbar-logo', [
          img(
            src: '/assets/logo-horizontal.svg',
            alt: 'Flutter Belgium',
            classes: 'navbar-logo-img',
          ),
        ]),
        nav(classes: 'navbar-links', [
          a(href: '#about', classes: 'navbar-link', [text('About')]),
          a(href: '#meetups', classes: 'navbar-link', [text('Meetups')]),
          a(href: '#talks', classes: 'navbar-link', [text('Talks')]),
          a(href: '#join', classes: 'navbar-link', [text('Join')]),
        ]),
      ]),
    ]);
  }
}
```

- [ ] Run test to verify it passes:

```bash
dart test test/components/nav_bar_test.dart
```

Expected: 1 test PASS.

---

### Task 9: Hero section

**Files:**

- Create: `lib/components/hero_section.dart`
- Create: `test/components/hero_section_test.dart`

- [ ] Write failing test at `test/components/hero_section_test.dart`:

```dart
import 'package:flutter_belgium_website/components/hero_section.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:jaspr_test/jaspr_test.dart';
import 'package:test/test.dart';

void main() {
  const links = CommunityLinks(
    slackInviteUrl: 'https://slack.com/invite/test',
    youtubeChannelUrl: 'https://youtube.com/@test',
  );

  testComponents('HeroSection renders tagline and Slack CTA', (tester) async {
    await tester.pumpComponent(HeroSection(communityLinks: links));

    expect(find.text('Join us on Slack'), findsOneComponent);
    expect(find.byTag('section'), findsOneComponent);
  });
}
```

- [ ] Run to verify it fails:

```bash
dart test test/components/hero_section_test.dart
```

Expected: error — file not found.

- [ ] Create `lib/components/hero_section.dart`:

```dart
import 'package:jaspr/jaspr.dart';

import '../data/models/community_links.dart';

class HeroSection extends StatelessComponent {
  const HeroSection({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section(classes: 'hero', [
      div(classes: 'hero-inner', [
        img(
          src: '/assets/logo-stacked.svg',
          alt: 'Flutter Belgium',
          classes: 'hero-logo',
        ),
        h1(classes: 'hero-tagline', [
          text('The Belgian Flutter community'),
        ]),
        p(classes: 'hero-sub', [
          text(
            'We bring Flutter developers across Belgium together through '
            'meetups, talks, and an active Slack community.',
          ),
        ]),
        div(classes: 'hero-actions', [
          a(
            href: communityLinks.slackInviteUrl,
            classes: 'btn btn-primary',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [text('Join us on Slack')],
          ),
          a(
            href: '#meetups',
            classes: 'btn btn-secondary',
            [text('See meetups')],
          ),
        ]),
      ]),
    ]);
  }
}
```

- [ ] Run test to verify it passes:

```bash
dart test test/components/hero_section_test.dart
```

Expected: 1 test PASS.

---

### Task 10: About section

**Files:**

- Create: `lib/components/about_section.dart`

No dedicated test — static content with no logic to verify.

- [ ] Create `lib/components/about_section.dart`:

```dart
import 'package:jaspr/jaspr.dart';

class AboutSection extends StatelessComponent {
  const AboutSection({super.key});

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section(id: 'about', classes: 'about', [
      div(classes: 'about-inner', [
        p(classes: 'section-label', [text('About us')]),
        h2(classes: 'section-title', [text('Flutter developers, made in Belgium')]),
        p(classes: 'section-body', [
          text(
            'Flutter Belgium is a community of Flutter developers across Belgium. '
            'Every two to three months we host a meetup at a Belgian company that '
            'uses Flutter in production. Talks are recorded and published on YouTube, '
            'and our Slack is where the conversation keeps going between events.',
          ),
        ]),
      ]),
    ]);
  }
}
```

---

### Task 11: Next Meetup section

**Files:**

- Create: `lib/components/next_meetup_section.dart`
- Create: `test/components/next_meetup_section_test.dart`

- [ ] Write failing test at `test/components/next_meetup_section_test.dart`:

```dart
import 'package:flutter_belgium_website/components/next_meetup_section.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:jaspr_test/jaspr_test.dart';
import 'package:test/test.dart';

void main() {
  const links = CommunityLinks(
    slackInviteUrl: 'https://slack.com/invite/test',
    youtubeChannelUrl: 'https://youtube.com/@test',
  );

  final meetup = Meetup(
    id: 'next',
    title: 'Flutter Belgium #4',
    date: DateTime(2024, 9, 19),
    hostCompany: 'Cronos',
    location: 'Leuven',
  );

  testComponents('NextMeetupSection shows meetup details when meetup provided', (tester) async {
    await tester.pumpComponent(
      NextMeetupSection(meetup: meetup, communityLinks: links),
    );
    expect(find.text('Cronos'), findsOneComponent);
    expect(find.text('Leuven'), findsOneComponent);
  });

  testComponents('NextMeetupSection shows fallback when no meetup', (tester) async {
    await tester.pumpComponent(
      NextMeetupSection(meetup: null, communityLinks: links),
    );
    expect(find.text('No upcoming meetup scheduled yet.'), findsOneComponent);
  });
}
```

- [ ] Run to verify it fails:

```bash
dart test test/components/next_meetup_section_test.dart
```

Expected: error — file not found.

- [ ] Create `lib/components/next_meetup_section.dart`:

```dart
import 'package:jaspr/jaspr.dart';

import '../data/models/community_links.dart';
import '../data/models/meetup.dart';

class NextMeetupSection extends StatelessComponent {
  const NextMeetupSection({
    required this.meetup,
    required this.communityLinks,
    super.key,
  });

  final Meetup? meetup;
  final CommunityLinks communityLinks;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section(id: 'meetups', classes: 'next-meetup', [
      div(classes: 'next-meetup-inner', [
        p(classes: 'section-label', [text('Next meetup')]),
        h2(classes: 'section-title', [text('Join us at our next event')]),
        if (meetup != null) ..._meetupContent(meetup!) else _noMeetup(),
      ]),
    ]);
  }

  Iterable<Component> _meetupContent(Meetup meetup) sync* {
    yield div(classes: 'meetup-meta', [
      _metaItem('Date', _formatDate(meetup.date)),
      _metaItem('Hosted by', meetup.hostCompany),
      _metaItem('Location', meetup.location),
    ]);
    if (meetup.description != null) {
      yield p(classes: 'section-body', [text(meetup.description!)]);
    }
    yield div(classes: 'hero-actions', [
      a(
        href: communityLinks.slackInviteUrl,
        classes: 'btn btn-outline-white',
        attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
        [text('Get notified on Slack')],
      ),
    ]);
  }

  Component _noMeetup() => p(classes: 'no-meetup-message', [
        text('No upcoming meetup scheduled yet. Follow us on Slack to stay updated.'),
      ]);

  Component _metaItem(String label, String value) => div(classes: 'meetup-meta-item', [
        span(classes: 'meetup-meta-label', [text(label)]),
        span(classes: 'meetup-meta-value', [text(value)]),
      ]);

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
```

- [ ] Run test to verify it passes:

```bash
dart test test/components/next_meetup_section_test.dart
```

Expected: 2 tests PASS.

---

### Task 12: Past Meetups section

**Files:**

- Create: `lib/components/past_meetups_section.dart`
- Create: `test/components/past_meetups_section_test.dart`

- [ ] Write failing test at `test/components/past_meetups_section_test.dart`:

```dart
import 'package:flutter_belgium_website/components/past_meetups_section.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:jaspr_test/jaspr_test.dart';
import 'package:test/test.dart';

void main() {
  final meetups = [
    Meetup(
      id: '1',
      title: 'Flutter Belgium #1',
      date: DateTime(2023, 11, 16),
      hostCompany: 'iO',
      location: 'Ghent',
    ),
    Meetup(
      id: '2',
      title: 'Flutter Belgium #2',
      date: DateTime(2024, 2, 22),
      hostCompany: 'Zimmo',
      location: 'Antwerp',
    ),
  ];

  testComponents('PastMeetupsSection renders a card per meetup', (tester) async {
    await tester.pumpComponent(PastMeetupsSection(meetups: meetups));

    expect(find.text('iO'), findsOneComponent);
    expect(find.text('Zimmo'), findsOneComponent);
  });
}
```

- [ ] Run to verify it fails:

```bash
dart test test/components/past_meetups_section_test.dart
```

Expected: error — file not found.

- [ ] Create `lib/components/past_meetups_section.dart`:

```dart
import 'package:jaspr/jaspr.dart';

import '../data/models/meetup.dart';

class PastMeetupsSection extends StatelessComponent {
  const PastMeetupsSection({required this.meetups, super.key});

  final List<Meetup> meetups;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section(classes: 'past-meetups', [
      div(classes: 'past-meetups-inner', [
        p(classes: 'section-label', [text('Past meetups')]),
        h2(classes: 'section-title', [text('Where we\'ve been')]),
        div(classes: 'meetups-grid', [
          for (final meetup in meetups) _MeetupCard(meetup: meetup),
        ]),
      ]),
    ]);
  }
}

class _MeetupCard extends StatelessComponent {
  const _MeetupCard({required this.meetup});

  final Meetup meetup;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield article(classes: 'meetup-card', [
      p(classes: 'meetup-card-date', [text(_formatDate(meetup.date))]),
      h3(classes: 'meetup-card-title', [text(meetup.title)]),
      p(classes: 'meetup-card-host', [
        text('${meetup.hostCompany} · ${meetup.location}'),
      ]),
      if (meetup.description != null)
        p(classes: 'meetup-card-description', [text(meetup.description!)]),
    ]);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
```

- [ ] Run test to verify it passes:

```bash
dart test test/components/past_meetups_section_test.dart
```

Expected: 1 test PASS.

---

### Task 13: Talks section

**Files:**

- Create: `lib/components/talks_section.dart`
- Create: `test/components/talks_section_test.dart`

- [ ] Write failing test at `test/components/talks_section_test.dart`:

```dart
import 'package:flutter_belgium_website/components/talks_section.dart';
import 'package:flutter_belgium_website/data/models/speaker.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:jaspr_test/jaspr_test.dart';
import 'package:test/test.dart';

void main() {
  final talks = [
    Talk(
      id: 't1',
      title: 'Getting Started with Flutter',
      speaker: const Speaker(name: 'Jan Peeters', company: 'iO'),
      meetupId: '1',
      meetupTitle: 'Flutter Belgium #1',
      youtubeUrl: 'https://youtube.com/watch?v=abc',
    ),
    Talk(
      id: 't2',
      title: 'State Management',
      speaker: const Speaker(name: 'Lisa Maes'),
      meetupId: '2',
      meetupTitle: 'Flutter Belgium #2',
    ),
  ];

  testComponents('TalksSection renders a card per talk', (tester) async {
    await tester.pumpComponent(TalksSection(talks: talks));

    expect(find.text('Getting Started with Flutter'), findsOneComponent);
    expect(find.text('State Management'), findsOneComponent);
  });

  testComponents('TalksSection shows YouTube link when youtubeUrl is set', (tester) async {
    await tester.pumpComponent(TalksSection(talks: [talks[0]]));
    expect(find.text('Watch on YouTube'), findsOneComponent);
  });

  testComponents('TalksSection shows fallback when no youtubeUrl', (tester) async {
    await tester.pumpComponent(TalksSection(talks: [talks[1]]));
    expect(find.text('Recording coming soon'), findsOneComponent);
  });
}
```

- [ ] Run to verify it fails:

```bash
dart test test/components/talks_section_test.dart
```

Expected: error — file not found.

- [ ] Create `lib/components/talks_section.dart`:

```dart
import 'package:jaspr/jaspr.dart';

import '../data/models/talk.dart';

class TalksSection extends StatelessComponent {
  const TalksSection({required this.talks, super.key});

  final List<Talk> talks;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section(id: 'talks', classes: 'talks', [
      div(classes: 'talks-inner', [
        p(classes: 'section-label', [text('Talks')]),
        h2(classes: 'section-title', [text('Catch up on what you missed')]),
        div(classes: 'talks-grid', [
          for (final talk in talks) _TalkCard(talk: talk),
        ]),
      ]),
    ]);
  }
}

class _TalkCard extends StatelessComponent {
  const _TalkCard({required this.talk});

  final Talk talk;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield article(classes: 'talk-card', [
      span(classes: 'talk-meetup-badge', [text(talk.meetupTitle)]),
      h3(classes: 'talk-title', [text(talk.title)]),
      div(classes: 'talk-speaker', [
        span(classes: 'talk-speaker-name', [text(talk.speaker.name)]),
        if (talk.speaker.company != null) ...[
          text(' · '),
          span([text(talk.speaker.company!)]),
        ],
      ]),
      if (talk.youtubeUrl != null)
        a(
          href: talk.youtubeUrl!,
          classes: 'talk-link',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          [text('Watch on YouTube')],
        )
      else
        span(classes: 'talk-no-video', [text('Recording coming soon')]),
    ]);
  }
}
```

- [ ] Run test to verify it passes:

```bash
dart test test/components/talks_section_test.dart
```

Expected: 3 tests PASS.

---

### Task 14: Join section

**Files:**

- Create: `lib/components/join_section.dart`

No dedicated test — static content with two links, pattern covered by hero test.

- [ ] Create `lib/components/join_section.dart`:

```dart
import 'package:jaspr/jaspr.dart';

import '../data/models/community_links.dart';

class JoinSection extends StatelessComponent {
  const JoinSection({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield section(id: 'join', classes: 'join', [
      div(classes: 'join-inner', [
        h2(classes: 'section-title', [text('Join the community')]),
        p(classes: 'join-sub', [
          text(
            'Connect with Flutter developers across Belgium. '
            'Ask questions, share projects, and be the first to know about upcoming meetups.',
          ),
        ]),
        div(classes: 'join-actions', [
          a(
            href: communityLinks.slackInviteUrl,
            classes: 'btn btn-secondary',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [text('Join us on Slack')],
          ),
          a(
            href: communityLinks.youtubeChannelUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [text('YouTube')],
          ),
          a(
            href: communityLinks.meetupUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [text('Meetup')],
          ),
          a(
            href: communityLinks.linkedinUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [text('LinkedIn')],
          ),
          a(
            href: communityLinks.githubUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [text('GitHub')],
          ),
          a(
            href: communityLinks.madeInUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            [text('Made in Flutter Belgium')],
          ),
        ]),
      ]),
    ]);
  }
}
```

---

### Task 15: Footer

**Files:**

- Create: `lib/components/footer.dart`

The footer receives `communityLinks` to render social links. Update `App` and `app.dart` to pass it through.

- [ ] Update `lib/app.dart` — add `communityLinks` to the `Footer` constructor call:

```dart
yield Footer(communityLinks: communityLinks);
```

- [ ] Create `lib/components/footer.dart`:

```dart
import 'package:jaspr/jaspr.dart';

import '../data/models/community_links.dart';

class Footer extends StatelessComponent {
  const Footer({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield footer(classes: 'footer', [
      div(classes: 'footer-inner container', [
        img(
          src: '/assets/logo-horizontal.svg',
          alt: 'Flutter Belgium',
          classes: 'footer-logo',
        ),
        nav(classes: 'footer-social', [
          a(
            href: communityLinks.slackInviteUrl,
            classes: 'footer-social-link',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'Slack'},
            [text('Slack')],
          ),
          a(
            href: communityLinks.youtubeChannelUrl,
            classes: 'footer-social-link',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'YouTube'},
            [text('YouTube')],
          ),
          a(
            href: communityLinks.meetupUrl,
            classes: 'footer-social-link',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'Meetup'},
            [text('Meetup')],
          ),
          a(
            href: communityLinks.linkedinUrl,
            classes: 'footer-social-link',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'LinkedIn'},
            [text('LinkedIn')],
          ),
          a(
            href: communityLinks.githubUrl,
            classes: 'footer-social-link',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'GitHub'},
            [text('GitHub')],
          ),
          a(
            href: communityLinks.madeInUrl,
            classes: 'footer-social-link',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'Made in Flutter Belgium'},
            [text('Made in Flutter Belgium')],
          ),
        ]),
        p(classes: 'footer-copy', [
          text('© ${DateTime.now().year} Flutter Belgium'),
        ]),
      ]),
    ]);
  }
}
```

- [ ] Add footer social link styles to `web/styles.css`:

```css
.footer-social {
  display: flex;
  flex-wrap: wrap;
  gap: 1.25rem;
}

.footer-social-link {
  font-size: 0.85rem;
  opacity: 0.6;
  transition: opacity 0.2s;
}

.footer-social-link:hover {
  opacity: 1;
}
```

---

### Task 16: Full build verification

- [ ] Run all tests:

```bash
dart test
```

Expected: all tests PASS.

- [ ] Start dev server and verify the site renders:

```bash
dart run jaspr serve
```

Open `http://localhost:8080`. Verify:

- NavBar is sticky at top, shows logo and anchor links
- Hero section has grey background, stacked logo, tagline, Slack CTA
- About section is white with community description
- Next Meetup section has navy background and shows mock meetup details
- Past Meetups section has grey background, 3 meetup cards
- Talks section is white, shows 4 talk cards; 3 have YouTube links, 1 shows "Recording coming soon"
- Join section has sky-blue background with two CTA buttons
- Footer has navy background with logo and copyright

---

### Task 17: GitHub Actions deploy workflow

**Files:**

- Create: `.github/workflows/deploy.yml`

- [ ] Create `.github/workflows/deploy.yml`:

```yaml
name: Build and Deploy

on:
  push:
    branches:
      - main
  repository_dispatch:
    types:
      - content-updated

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Dart
        uses: dart-lang/setup-dart@v1
        with:
          sdk: stable

      - name: Install dependencies
        run: dart pub get

      - name: Build static site
        run: dart run jaspr build

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v4
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/jaspr
```

> Note: verify `./build/jaspr` is the correct output path for your Jaspr version. Run `dart run jaspr build` locally and check where output files are written.

---

### Task 18: README

**Files:**

- Create: `README.md`

- [ ] Create `README.md`:

````markdown
# Flutter Belgium Website

The official website for [Flutter Belgium](https://flutterbelgium.be) — the Belgian Flutter community.

Built with [Jaspr](https://github.com/schultek/jaspr) and hosted on GitHub Pages.

## Local development

```bash
dart pub get
dart run jaspr serve
```
````

Open `http://localhost:8080`.

## Build

```bash
dart run jaspr build
```

Output is written to `build/jaspr/`.

## Custom domain

Configure `flutterbelgium.be` once in the repository **Settings → Pages → Custom domain**. GitHub Pages preserves this setting across deployments.

## Triggering a rebuild

When content changes in the API, trigger a rebuild by sending a `repository_dispatch` event:

```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_GITHUB_PAT" \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  https://api.github.com/repos/flutter-belgium/flutter-belgium-website/dispatches \
  -d '{"event_type":"content-updated"}'
```

Replace `YOUR_GITHUB_PAT` with a fine-grained GitHub Personal Access Token scoped to this repository with **Actions: write** permission. Generate one at **GitHub → Settings → Developer settings → Fine-grained tokens**.

Replace `flutter-belgium/flutter-belgium-website` with the actual `{owner}/{repo}` of this repository.

## Swapping mock data for the real API

When the API Dart package is published:

1. Add it to `pubspec.yaml` and run `dart pub get`
2. In `lib/main.dart`, replace:
   ```dart
   final repository = MockFlutterBelgiumRepository();
   ```
   with:
   ```dart
   final repository = ApiFlutterBelgiumRepository();
   ```
3. Delete `lib/data/models/` and `lib/data/repositories/mock_flutter_belgium_repository.dart`

## Brand assets

Place the following SVG files in `web/assets/` before building:

- `logo-stacked.svg`
- `logo-horizontal.svg`
- `logomark.svg`

Obtain these from the Flutter Belgium brand assets.

```

---

## Self-review

**Spec coverage:**
- ✅ Single scrollable homepage with 8 sections
- ✅ Repository pattern with mock, swap-ready for real API
- ✅ `repository_dispatch` trigger in deploy workflow
- ✅ README with rebuild trigger documentation and curl command
- ✅ No CNAME file — custom domain handled via GitHub Settings
- ✅ Google Sans Flex font with fallback note
- ✅ Brand colors: navy, sky, yellow, red, grey
- ✅ Light hero, dark next-meetup, alternating sections
- ✅ Talks cross-reference meetup via badge
- ✅ "No upcoming meetup" fallback state

**Placeholder scan:** None found.

**Type consistency:** All component constructors match their usage in `app.dart`. `Talk.meetupTitle` is used in `_TalkCard`. `Meetup.description` is nullable and guarded with `if` checks in both `NextMeetupSection` and `_MeetupCard`.
```
