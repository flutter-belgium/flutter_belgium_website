# Meetups & Talks Pages Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add meetup list pages (`/meetups/upcoming`, `/meetups/past`), a meetup detail page (`/meetups/:slug`), and a talk list page (`/talks`), backed by a unified `Person` model used across talks, testimonials, and Made In cross-references.

**Architecture:** Extend `FlutterBelgiumRepository` with new methods; add `Person`, `PersonCompany`, `PersonSocialLinks` models; update `Talk` and `Testimonial`; add four new Jaspr pages and a `MeetupPageShell` tab component. Home page sections become teasers showing 3 items with "View all" links.

**Tech Stack:** Dart 3.3+, Jaspr 0.23, jaspr_router, jaspr_test, vanilla CSS.

---

## File Map

**New models:**
- `lib/data/models/person_social_links.dart`
- `lib/data/models/person_company.dart`
- `lib/data/models/person.dart`

**Updated models:**
- `lib/data/models/talk.dart` — add id, title, date, meetupId, speakers; nullable youtubeUrl
- `lib/data/models/meetup.dart` — add `slug` computed getter
- `lib/data/models/testimonial.dart` — replace flat author fields with `author: Person`

**Deleted:**
- `lib/data/models/speaker.dart`

**Updated utility:**
- `lib/util/string_utils.dart` — new file; extract `toSlug` from `made_in_utils.dart`
- `lib/util/made_in_utils.dart` — import `toSlug` from `string_utils.dart`

**Updated repository:**
- `lib/data/repositories/flutter_belgium_repository.dart` — add `getUpcomingMeetups`, `getPersons`, `getMeetupBySlug`, `getTalksByMeetupId`
- `lib/data/repositories/mock_flutter_belgium_repository.dart` — implement new methods + rich mock data

**Updated components:**
- `lib/components/past_meetups_section.dart` — cards link to `/meetups/:slug`; add "View all" link; remove `meetupGroupUrl`
- `lib/components/talks_section.dart` — filter to video-only; add "View all" link
- `lib/components/next_meetup_section.dart` — add "View all upcoming" link
- `lib/components/testimonials_section.dart` — use `testimonial.author` (Person)

**New components:**
- `lib/components/meetups/meetup_page_shell.dart` — tab shell (upcoming/past)

**New pages:**
- `lib/pages/meetups/meetups_upcoming_page.dart`
- `lib/pages/meetups/meetups_past_page.dart`
- `lib/pages/meetups/meetup_detail_page.dart`
- `lib/pages/talks/talks_page.dart`

**Updated wiring:**
- `lib/main.server.dart` — new routes; fetch persons; pass trimmed lists to home page
- `lib/pages/home_page.dart` — remove `meetupGroupUrl` from `PastMeetupsSection`

**Updated tests:**
- `test/data/models/person_test.dart` — new
- `test/data/models/models_test.dart` — update Talk + Testimonial groups
- `test/data/repositories/mock_repository_test.dart` — update + add new method tests
- `test/components/past_meetups_section_test.dart` — update for new API
- `test/components/talks_section_test.dart` — update for nullable youtubeUrl
- `test/components/next_meetup_section_test.dart` — update for "View all" link
- `test/components/testimonials_section_test.dart` — update for Person author
- `test/components/meetups_upcoming_page_test.dart` — new
- `test/components/meetups_past_page_test.dart` — new
- `test/components/meetup_detail_page_test.dart` — new
- `test/components/talks_page_test.dart` — new

**CSS:**
- `web/styles.css` — add meetup page shell styles, "View all" link style, meetup detail talk card styles

---

## Task 1: Person, PersonCompany, PersonSocialLinks models

**Files:**
- Create: `lib/data/models/person_social_links.dart`
- Create: `lib/data/models/person_company.dart`
- Create: `lib/data/models/person.dart`
- Delete: `lib/data/models/speaker.dart`
- Create: `test/data/models/person_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/data/models/person_test.dart
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';
import 'package:test/test.dart';

void main() {
  group('PersonSocialLinks', () {
    test('all fields optional, defaults to null', () {
      const links = PersonSocialLinks();
      expect(links.githubUrl, isNull);
      expect(links.linkedinUrl, isNull);
      expect(links.twitterUrl, isNull);
      expect(links.websiteUrl, isNull);
    });

    test('constructs with provided fields', () {
      const links = PersonSocialLinks(
        githubUrl: 'https://github.com/test',
        linkedinUrl: 'https://linkedin.com/in/test',
      );
      expect(links.githubUrl, 'https://github.com/test');
      expect(links.twitterUrl, isNull);
    });
  });

  group('PersonCompany', () {
    test('constructs with all fields', () {
      const c = PersonCompany(
        name: 'Acme',
        jobTitle: 'Flutter Developer',
        isActive: true,
      );
      expect(c.name, 'Acme');
      expect(c.jobTitle, 'Flutter Developer');
      expect(c.isActive, isTrue);
    });
  });

  group('Person', () {
    const activeCompany = PersonCompany(
      name: 'impaktfull',
      jobTitle: 'Founder',
      isActive: true,
    );
    const inactiveCompany = PersonCompany(
      name: 'Old Corp',
      jobTitle: 'Dev',
      isActive: false,
    );
    const person = Person(
      id: 'p1',
      name: 'Koen Van Looveren',
      avatarUrl: '/assets/team/koen.jpeg',
      companies: [inactiveCompany, activeCompany],
      githubUsername: 'vanlooverenkoen',
      socialLinks: PersonSocialLinks(
        githubUrl: 'https://github.com/vanlooverenkoen',
      ),
    );

    test('constructs with all fields', () {
      expect(person.id, 'p1');
      expect(person.name, 'Koen Van Looveren');
      expect(person.githubUsername, 'vanlooverenkoen');
    });

    test('activeCompany returns the first isActive company', () {
      expect(person.activeCompany, activeCompany);
    });

    test('activeCompany returns null when no active company', () {
      const p = Person(
        id: 'p2',
        name: 'No Active',
        avatarUrl: '/avatar.jpg',
        companies: [inactiveCompany],
        socialLinks: PersonSocialLinks(),
      );
      expect(p.activeCompany, isNull);
    });

    test('activeCompany returns null when companies is empty', () {
      const p = Person(
        id: 'p3',
        name: 'Empty',
        avatarUrl: '/avatar.jpg',
        companies: [],
        socialLinks: PersonSocialLinks(),
      );
      expect(p.activeCompany, isNull);
    });

    test('githubUsername is optional', () {
      const p = Person(
        id: 'p4',
        name: 'No GitHub',
        avatarUrl: '/avatar.jpg',
        companies: [],
        socialLinks: PersonSocialLinks(),
      );
      expect(p.githubUsername, isNull);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
dart test test/data/models/person_test.dart
```

Expected: compile error — `person.dart`, `person_company.dart`, `person_social_links.dart` not found.

- [ ] **Step 3: Create PersonSocialLinks**

```dart
// lib/data/models/person_social_links.dart
class PersonSocialLinks {
  const PersonSocialLinks({
    this.githubUrl,
    this.linkedinUrl,
    this.twitterUrl,
    this.websiteUrl,
  });

  final String? githubUrl;
  final String? linkedinUrl;
  final String? twitterUrl;
  final String? websiteUrl;
}
```

- [ ] **Step 4: Create PersonCompany**

```dart
// lib/data/models/person_company.dart
class PersonCompany {
  const PersonCompany({
    required this.name,
    required this.jobTitle,
    required this.isActive,
  });

  final String name;
  final String jobTitle;
  final bool isActive;
}
```

- [ ] **Step 5: Create Person**

```dart
// lib/data/models/person.dart
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.companies,
    this.githubUsername,
    required this.socialLinks,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final List<PersonCompany> companies;
  final String? githubUsername;
  final PersonSocialLinks socialLinks;

  PersonCompany? get activeCompany {
    final matches = companies.where((c) => c.isActive);
    return matches.isEmpty ? null : matches.first;
  }
}
```

- [ ] **Step 6: Delete Speaker model**

Delete `lib/data/models/speaker.dart`.

- [ ] **Step 7: Run tests to verify they pass**

```bash
dart test test/data/models/person_test.dart
```

Expected: All tests pass.

- [ ] **Step 8: Commit**

```bash
git add lib/data/models/person_social_links.dart lib/data/models/person_company.dart lib/data/models/person.dart test/data/models/person_test.dart
git rm lib/data/models/speaker.dart
git commit -m "feat: add Person, PersonCompany, PersonSocialLinks models; remove Speaker"
```

---

## Task 2: Update Talk model

**Files:**
- Modify: `lib/data/models/talk.dart`
- Modify: `test/data/models/models_test.dart` (Talk group)
- Modify: `test/components/talks_section_test.dart`

- [ ] **Step 1: Update Talk group in models_test.dart**

Replace the `group('Talk', ...)` block in `test/data/models/models_test.dart`:

```dart
// Add imports at top of file:
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';

// Replace Talk group:
group('Talk', () {
  const talk = Talk(
    id: 'talk-1',
    title: 'Building reactive UIs',
    date: DateTime(2026, 2, 3),
    youtubeUrl: 'https://www.youtube.com/watch?v=abc123',
    meetupId: 'meetup-1',
    speakers: [],
  );

  test('constructs with all fields', () {
    expect(talk.id, 'talk-1');
    expect(talk.title, 'Building reactive UIs');
    expect(talk.meetupId, 'meetup-1');
  });

  test('thumbnailUrl derived from youtubeUrl when present', () {
    expect(talk.thumbnailUrl, contains('abc123'));
  });

  test('thumbnailUrl is null when youtubeUrl is null', () {
    const noVideo = Talk(
      id: 'talk-2',
      title: 'No Video Yet',
      date: DateTime(2026, 2, 3),
      meetupId: 'meetup-1',
      speakers: [],
    );
    expect(noVideo.thumbnailUrl, isNull);
  });
});
```

- [ ] **Step 2: Update TalksSection test for nullable youtubeUrl**

Replace `test/components/talks_section_test.dart`:

```dart
import 'package:flutter_belgium_website/components/talks_section.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const talkWithVideo = Talk(
    id: 't1',
    title: 'Test Talk',
    date: DateTime(2026, 1, 1),
    youtubeUrl: 'https://youtube.com/watch?v=abc',
    meetupId: 'm1',
    speakers: [],
  );
  const talkWithoutVideo = Talk(
    id: 't2',
    title: 'No Video',
    date: DateTime(2026, 1, 1),
    meetupId: 'm1',
    speakers: [],
  );

  testComponents('TalksSection renders one card per talk with video',
      (tester) async {
    tester.pumpComponent(TalksSection(talks: [talkWithVideo, talkWithVideo]));
    expect(find.tag('img'), findsNComponents(2));
  });

  testComponents('TalksSection skips talks without a YouTube URL',
      (tester) async {
    tester.pumpComponent(
        TalksSection(talks: [talkWithVideo, talkWithoutVideo]));
    expect(find.tag('img'), findsOneComponent);
  });

  testComponents('TalksSection wraps each card in a YouTube link',
      (tester) async {
    tester.pumpComponent(TalksSection(talks: [talkWithVideo]));
    expect(find.tag('a'), findsNComponents(2)); // 1 talk card + 1 "View all"
  });
}
```

- [ ] **Step 3: Run tests to verify they fail**

```bash
dart test test/data/models/models_test.dart test/components/talks_section_test.dart
```

Expected: compile error — Talk constructor mismatch.

- [ ] **Step 4: Update Talk model**

```dart
// lib/data/models/talk.dart
import 'package:flutter_belgium_website/data/models/person.dart';

class Talk {
  const Talk({
    required this.id,
    required this.title,
    required this.date,
    this.youtubeUrl,
    required this.meetupId,
    required this.speakers,
  });

  final String id;
  final String title;
  final DateTime date;
  final String? youtubeUrl;
  final String meetupId;
  final List<Person> speakers;

  String? get thumbnailUrl {
    if (youtubeUrl == null) return null;
    final videoId = Uri.tryParse(youtubeUrl!)?.queryParameters['v'];
    if (videoId == null) return null;
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
```

- [ ] **Step 5: Update TalksSection to filter and add "View all" link**

```dart
// lib/components/talks_section.dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/talk.dart';

class TalksSection extends StatelessComponent {
  const TalksSection({required this.talks, super.key});

  final List<Talk> talks;

  @override
  Component build(BuildContext context) {
    final withVideo = talks.where((t) => t.youtubeUrl != null).toList();
    return section(id: 'talks', classes: 'talks', [
      div(classes: 'talks-inner', [
        const p(classes: 'section-label', [Component.text('Talks')]),
        const h2(
            classes: 'section-title',
            [Component.text('Catch up on what you missed')]),
        div(classes: 'talks-grid', [
          for (final talk in withVideo) _TalkCard(talk: talk),
        ]),
        a(
          [const Component.text('View all talks →')],
          href: '/talks',
          classes: 'view-all-link',
        ),
      ]),
    ]);
  }
}

class _TalkCard extends StatelessComponent {
  const _TalkCard({required this.talk});

  final Talk talk;

  @override
  Component build(BuildContext context) {
    return a(
      [
        article(classes: 'talk-card', [
          img(
            src: talk.thumbnailUrl!,
            alt: talk.title,
            classes: 'talk-thumbnail',
          ),
        ]),
      ],
      href: talk.youtubeUrl!,
      classes: 'talk-link',
      target: Target.blank,
      attributes: {'rel': 'noopener noreferrer'},
    );
  }
}
```

- [ ] **Step 6: Update mock Talk data in MockFlutterBelgiumRepository**

In `lib/data/repositories/mock_flutter_belgium_repository.dart`, add the three static const person entries and update `_talks`. Add at top of class body:

```dart
// Add imports:
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';

// Add at top of class:
static const _koen = Person(
  id: 'person-koen',
  name: 'Koen Van Looveren',
  avatarUrl: '/assets/team/koen.jpeg',
  companies: [
    PersonCompany(
        name: 'impaktfull',
        jobTitle: 'Founder & Flutter Developer',
        isActive: true),
  ],
  githubUsername: 'vanlooverenkoen',
  socialLinks: PersonSocialLinks(
    githubUrl: 'https://github.com/vanlooverenkoen',
    linkedinUrl: 'https://www.linkedin.com/in/koenvanlooveren/',
  ),
);

static const _jens = Person(
  id: 'person-jens',
  name: 'Jens Gyselinck',
  avatarUrl: '/assets/team/jens.jpeg',
  companies: [
    PersonCompany(
        name: 'diskwriter',
        jobTitle: 'Founder & Flutter Developer',
        isActive: true),
  ],
  githubUsername: 'diskwriter',
  socialLinks: PersonSocialLinks(
    githubUrl: 'https://github.com/diskwriter',
    linkedinUrl: 'https://www.linkedin.com/in/jensgyselinck/',
  ),
);

static const _kris = Person(
  id: 'person-kris',
  name: 'Kris Pypen',
  avatarUrl: '/assets/team/kris.jpeg',
  companies: [
    PersonCompany(
        name: 'Flutter Belgium',
        jobTitle: 'Organiser',
        isActive: true),
  ],
  githubUsername: 'krispypen',
  socialLinks: PersonSocialLinks(
    githubUrl: 'https://github.com/krispypen',
    linkedinUrl: 'https://www.linkedin.com/in/krispypen/',
  ),
);
```

Replace `_talks`:

```dart
static const List<Talk> _talks = [
  Talk(
    id: 'talk-1',
    title: 'Building performant Flutter apps',
    date: DateTime(2026, 2, 3),
    youtubeUrl: 'https://www.youtube.com/watch?v=1bM6JiwLMX0',
    meetupId: 'meetup-3',
    speakers: [_koen],
  ),
  Talk(
    id: 'talk-2',
    title: 'State management in 2025',
    date: DateTime(2025, 10, 8),
    youtubeUrl: 'https://www.youtube.com/watch?v=iQQhv72eYRA',
    meetupId: 'meetup-2',
    speakers: [_jens],
  ),
  Talk(
    id: 'talk-3',
    title: 'Flutter for desktop',
    date: DateTime(2025, 6, 11),
    youtubeUrl: 'https://www.youtube.com/watch?v=J08BJIVDucI',
    meetupId: 'meetup-1',
    speakers: [_kris],
  ),
];
```

Also update `mock_repository_test.dart` — replace the `getAllTalks` test:

```dart
test('getAllTalks returns talks with non-empty id, title, and meetupId',
    () async {
  final talks = await repo.getAllTalks();
  expect(talks, isA<List<Talk>>());
  expect(talks, isNotEmpty);
  for (final talk in talks) {
    expect(talk.id, isNotEmpty);
    expect(talk.title, isNotEmpty);
    expect(talk.meetupId, isNotEmpty);
  }
});
```

- [ ] **Step 7: Run tests**

```bash
dart test test/data/models/models_test.dart test/components/talks_section_test.dart test/data/repositories/mock_repository_test.dart
```

Expected: All pass.

- [ ] **Step 8: Run all tests**

```bash
dart test
```

Expected: All pass.

- [ ] **Step 9: Commit**

```bash
git add lib/data/models/talk.dart lib/components/talks_section.dart lib/data/repositories/mock_flutter_belgium_repository.dart test/data/models/models_test.dart test/components/talks_section_test.dart test/data/repositories/mock_repository_test.dart
git commit -m "feat: extend Talk model with id, title, date, speakers, nullable youtubeUrl"
```

---

## Task 3: Update Testimonial model and TestimonialsSection

**Files:**
- Modify: `lib/data/models/testimonial.dart`
- Modify: `lib/components/testimonials_section.dart`
- Modify: `lib/data/repositories/mock_flutter_belgium_repository.dart` (testimonials)
- Modify: `test/data/models/models_test.dart` (Testimonial group)
- Modify: `test/data/repositories/mock_repository_test.dart` (testimonials test)
- Modify: `lib/main.server.dart` (shuffleNoAdjacentDuplicates key)

- [ ] **Step 1: Update Testimonial group in models_test.dart**

Replace `group('Testimonial', ...)`:

```dart
group('Testimonial', () {
  test('constructs with text and Person author', () {
    const t = Testimonial(
      text: 'Great meetup!',
      author: Person(
        id: 'p1',
        name: 'Jan Peeters',
        avatarUrl: '/avatar.jpg',
        companies: [
          PersonCompany(
              name: 'iO', jobTitle: 'Flutter Developer', isActive: true)
        ],
        socialLinks: PersonSocialLinks(),
      ),
    );
    expect(t.text, 'Great meetup!');
    expect(t.author.name, 'Jan Peeters');
    expect(t.author.activeCompany?.name, 'iO');
  });
});
```

Add missing imports at top of `models_test.dart` (Person, PersonCompany, PersonSocialLinks already added in Task 2). Remove the old `Testimonial` import if the constructor changed.

- [ ] **Step 2: Run test to verify failure**

```bash
dart test test/data/models/models_test.dart
```

Expected: compile error — Testimonial constructor mismatch.

- [ ] **Step 3: Update Testimonial model**

```dart
// lib/data/models/testimonial.dart
import 'package:flutter_belgium_website/data/models/person.dart';

class Testimonial {
  const Testimonial({
    required this.text,
    required this.author,
  });

  final String text;
  final Person author;
}
```

- [ ] **Step 4: Update TestimonialsSection to use Person**

In `lib/components/testimonials_section.dart`, update `_card()`:

```dart
Component _card(Testimonial testimonial) {
  final author = testimonial.author;
  final company = author.activeCompany;
  return div(classes: 'testimonial-card', [
    p(classes: 'testimonial-text', [Component.text(testimonial.text)]),
    div(classes: 'testimonial-author', [
      img(
        src: author.avatarUrl,
        alt: author.name,
        classes: 'testimonial-avatar',
      ),
      div(classes: 'testimonial-author-info', [
        p(classes: 'testimonial-name', [Component.text(author.name)]),
        if (company != null)
          p(classes: 'testimonial-role',
              [Component.text('${company.jobTitle} at ${company.name}')]),
      ]),
    ]),
  ]);
}
```

Remove the `authorAvatarUrl` null-check branch (Person always has an avatarUrl).

Also update the import at the top of `testimonials_section.dart`:
```dart
import 'package:flutter_belgium_website/data/models/testimonial.dart';
// (no change needed — Testimonial is still Testimonial)
```

- [ ] **Step 5: Update mock testimonials in MockFlutterBelgiumRepository**

Replace `_testimonials`:

```dart
static const List<Testimonial> _testimonials = [
  Testimonial(
    text:
        'Building Flutter Belgium has been one of the most rewarding things I have done as a developer. Seeing the community grow and watching people connect over a shared passion for Flutter makes every event worth it.',
    author: _koen,
  ),
  Testimonial(
    text:
        'I joined as an organiser because I wanted to give back to the community that helped me grow as an engineer. Flutter Belgium is the place where Belgian Flutter developers come to learn and inspire each other.',
    author: _jens,
  ),
  Testimonial(
    text:
        'What started as a small idea has grown into a thriving community of Flutter developers across Belgium. The conversations and connections that happen at every meetup continue to surprise and motivate me.',
    author: _kris,
  ),
];
```

- [ ] **Step 6: Update shuffle key in main.server.dart**

In `lib/main.server.dart`, update the testimonials shuffle:

```dart
final testimonials = shuffleNoAdjacentDuplicates(
  await repository.getTestimonials(),
  (t) => t.author.name,  // was: t.authorName
);
```

- [ ] **Step 7: Update mock_repository_test testimonials test**

Replace the `getTestimonials` test:

```dart
test('getTestimonials returns 3 testimonials with non-empty fields',
    () async {
  final testimonials = await repo.getTestimonials();
  expect(testimonials, isA<List<Testimonial>>());
  expect(testimonials, hasLength(3));
  for (final t in testimonials) {
    expect(t.text, isNotEmpty);
    expect(t.author.name, isNotEmpty);
    expect(t.author.activeCompany, isNotNull);
  }
});
```

- [ ] **Step 8: Run all tests**

```bash
dart test
```

Expected: All pass.

- [ ] **Step 9: Commit**

```bash
git add lib/data/models/testimonial.dart lib/components/testimonials_section.dart lib/data/repositories/mock_flutter_belgium_repository.dart lib/main.server.dart test/data/models/models_test.dart test/data/repositories/mock_repository_test.dart
git commit -m "feat: Testimonial uses Person model; update TestimonialsSection"
```

---

## Task 4: Extract toSlug + add Meetup.slug

**Files:**
- Create: `lib/util/string_utils.dart`
- Modify: `lib/util/made_in_utils.dart`
- Modify: `lib/data/models/meetup.dart`
- Modify: `test/data/models/models_test.dart` (Meetup group)
- Modify: `test/util/made_in_utils_test.dart` (import update only)

- [ ] **Step 1: Update Meetup group in models_test.dart**

Add to `group('Meetup', ...)`:

```dart
test('slug is derived from title', () {
  final meetup = Meetup(
    id: '1',
    title: 'Flutter Belgium #22',
    date: DateTime(2026, 2, 3),
    hostCompany: 'Acme',
    location: 'Ghent',
  );
  expect(meetup.slug, 'flutter-belgium-22');
});
```

- [ ] **Step 2: Run test to verify failure**

```bash
dart test test/data/models/models_test.dart
```

Expected: `NoSuchMethodError` — `slug` not found on Meetup.

- [ ] **Step 3: Create string_utils.dart**

```dart
// lib/util/string_utils.dart
String toSlug(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
      .replaceAll(RegExp(r'\s+'), '-');
}
```

- [ ] **Step 4: Update made_in_utils.dart to import from string_utils**

```dart
// lib/util/made_in_utils.dart
import 'package:flutter_belgium_website/util/string_utils.dart';

export 'package:flutter_belgium_website/util/string_utils.dart' show toSlug;

String toLocalImagePath(String url) {
  const apiBase = 'https://api.madein.flutterbelgium.be/';
  const githubBase = 'https://avatars.githubusercontent.com/';

  if (url.startsWith(apiBase)) {
    final path = url.substring(apiBase.length);
    return 'assets/made_in/${path.replaceFirst('/images/', '/')}';
  }
  if (url.startsWith(githubBase)) {
    final username = url.substring(githubBase.length).split('?').first;
    return 'assets/made_in/developers/$username/avatar.jpg';
  }
  return url;
}
```

- [ ] **Step 5: Add slug getter to Meetup**

```dart
// lib/data/models/meetup.dart
import 'package:flutter_belgium_website/util/string_utils.dart';

class Meetup {
  const Meetup({
    required this.id,
    required this.title,
    required this.date,
    required this.hostCompany,
    required this.location,
    this.description,
    this.thumbnailUrl,
    this.meetupUrl,
  });

  final String id;
  final String title;
  final DateTime date;
  final String hostCompany;
  final String location;
  final String? description;
  final String? thumbnailUrl;
  final String? meetupUrl;

  String get slug => toSlug(title);
}
```

- [ ] **Step 6: Run all tests**

```bash
dart test
```

Expected: All pass. (The `made_in_utils_test.dart` still works because `toSlug` is re-exported from `made_in_utils.dart`.)

- [ ] **Step 7: Commit**

```bash
git add lib/util/string_utils.dart lib/util/made_in_utils.dart lib/data/models/meetup.dart test/data/models/models_test.dart
git commit -m "feat: extract toSlug to string_utils; add Meetup.slug computed getter"
```

---

## Task 5: Repository — new methods and rich mock data

**Files:**
- Modify: `lib/data/repositories/flutter_belgium_repository.dart`
- Modify: `lib/data/repositories/mock_flutter_belgium_repository.dart`
- Modify: `test/data/repositories/mock_repository_test.dart`

- [ ] **Step 1: Write failing repository tests**

Add to `test/data/repositories/mock_repository_test.dart`:

```dart
// Add import:
import 'package:flutter_belgium_website/data/models/person.dart';

// Add tests:
test('getUpcomingMeetups returns meetups sorted ascending by date', () async {
  final meetups = await repo.getUpcomingMeetups();
  expect(meetups, isA<List<Meetup>>());
  for (var i = 0; i < meetups.length - 1; i++) {
    expect(meetups[i].date.isBefore(meetups[i + 1].date), isTrue);
  }
});

test('getPersons returns persons with non-empty id and name', () async {
  final persons = await repo.getPersons();
  expect(persons, isA<List<Person>>());
  expect(persons, isNotEmpty);
  for (final p in persons) {
    expect(p.id, isNotEmpty);
    expect(p.name, isNotEmpty);
  }
});

test('getMeetupBySlug returns the correct meetup', () async {
  final meetup = await repo.getMeetupBySlug('flutter-belgium-26');
  expect(meetup, isNotNull);
  expect(meetup!.id, 'meetup-3');
});

test('getMeetupBySlug returns null for unknown slug', () async {
  final meetup = await repo.getMeetupBySlug('does-not-exist');
  expect(meetup, isNull);
});

test('getTalksByMeetupId returns talks for that meetup only', () async {
  final talks = await repo.getTalksByMeetupId('meetup-3');
  expect(talks, isNotEmpty);
  for (final t in talks) {
    expect(t.meetupId, 'meetup-3');
  }
});
```

- [ ] **Step 2: Run to verify failure**

```bash
dart test test/data/repositories/mock_repository_test.dart
```

Expected: compile error — `getUpcomingMeetups`, `getPersons`, etc. not defined.

- [ ] **Step 3: Update FlutterBelgiumRepository interface**

```dart
// lib/data/repositories/flutter_belgium_repository.dart
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/sponsor.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/models/team_member.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';

abstract class FlutterBelgiumRepository {
  Future<Meetup?> getNextMeetup();
  Future<List<Meetup>> getUpcomingMeetups();
  Future<List<Meetup>> getPastMeetups();
  Future<Meetup?> getMeetupBySlug(String slug);
  Future<List<Talk>> getAllTalks();
  Future<List<Talk>> getTalksByMeetupId(String meetupId);
  Future<List<Person>> getPersons();
  Future<CommunityLinks> getCommunityLinks();
  Future<List<Company>> getHostingCompanies();
  Future<List<Testimonial>> getTestimonials();
  Future<List<TeamMember>> getTeamMembers();
  Future<List<Sponsor>> getSponsors();
}
```

- [ ] **Step 4: Update MockFlutterBelgiumRepository**

Add a unified `_allMeetups` list (combining past + upcoming) and implement all new methods. Replace the existing separate `_pastMeetups` and `getNextMeetup`/`getPastMeetups` implementations:

```dart
// Replace _pastMeetups with _allMeetups:
static const List<Meetup> _allMeetups = [
  Meetup(
    id: 'meetup-3',
    title: 'Flutter Belgium #26',
    date: DateTime(2026, 2, 3),
    hostCompany: 'ACA Group',
    location: 'Gent',
    thumbnailUrl: '/assets/meetup/meetup_26.avif',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/312351623',
  ),
  Meetup(
    id: 'meetup-2',
    title: 'Flutter Belgium #25',
    date: DateTime(2025, 10, 8),
    hostCompany: 'icapps',
    location: 'Antwerp',
    thumbnailUrl: '/assets/meetup/meetup_25.avif',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/306394784',
  ),
  Meetup(
    id: 'meetup-1',
    title: 'Flutter Belgium #24',
    date: DateTime(2025, 6, 11),
    hostCompany: 'MobileGeneration',
    location: 'Brussels',
    thumbnailUrl: '/assets/meetup/meetup_24.avif',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/306394783',
  ),
  Meetup(
    id: 'meetup-next',
    title: 'Flutter Belgium #27',
    date: DateTime(2026, 9, 19),
    hostCompany: 'Cronos',
    location: 'Leuven',
    thumbnailUrl: '/assets/meetup/meetup_27.avif',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/314638952',
  ),
];

static const List<Person> _persons = [_koen, _jens, _kris];

// Replace method implementations:
@override
Future<Meetup?> getNextMeetup() async {
  final upcoming = await getUpcomingMeetups();
  return upcoming.isEmpty ? null : upcoming.first;
}

@override
Future<List<Meetup>> getUpcomingMeetups() async {
  final now = DateTime.now();
  return List.unmodifiable(
    ([..._allMeetups]
      ..removeWhere((m) => m.date.isBefore(now))
      ..sort((a, b) => a.date.compareTo(b.date))),
  );
}

@override
Future<List<Meetup>> getPastMeetups() async {
  final now = DateTime.now();
  return List.unmodifiable(
    ([..._allMeetups]
      ..removeWhere((m) => !m.date.isBefore(now))
      ..sort((a, b) => b.date.compareTo(a.date))),
  );
}

@override
Future<Meetup?> getMeetupBySlug(String slug) async {
  try {
    return _allMeetups.firstWhere((m) => m.slug == slug);
  } catch (_) {
    return null;
  }
}

@override
Future<List<Person>> getPersons() async => List.unmodifiable(_persons);

@override
Future<List<Talk>> getAllTalks() async {
  final sorted = [..._talks]..sort((a, b) => b.date.compareTo(a.date));
  return List.unmodifiable(sorted);
}

@override
Future<List<Talk>> getTalksByMeetupId(String meetupId) async {
  return List.unmodifiable(_talks.where((t) => t.meetupId == meetupId));
}
```

- [ ] **Step 5: Run all tests**

```bash
dart test
```

Expected: All pass.

- [ ] **Step 6: Commit**

```bash
git add lib/data/repositories/flutter_belgium_repository.dart lib/data/repositories/mock_flutter_belgium_repository.dart test/data/repositories/mock_repository_test.dart
git commit -m "feat: add getUpcomingMeetups, getPersons, getMeetupBySlug, getTalksByMeetupId to repository"
```

---

## Task 6: Home page teasers

**Files:**
- Modify: `lib/components/past_meetups_section.dart`
- Modify: `lib/components/next_meetup_section.dart`
- Modify: `lib/pages/home_page.dart`
- Modify: `lib/main.server.dart`
- Modify: `web/styles.css`
- Modify: `test/components/past_meetups_section_test.dart`
- Modify: `test/components/next_meetup_section_test.dart`

- [ ] **Step 1: Update PastMeetupsSection tests**

Replace `test/components/past_meetups_section_test.dart`:

```dart
import 'package:flutter_belgium_website/components/past_meetups_section.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  final meetups = [
    Meetup(
      id: '1',
      title: 'Flutter Belgium #1',
      date: DateTime(2023, 11, 16),
      hostCompany: 'iO',
      location: 'Ghent',
      thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif',
    ),
    Meetup(
      id: '2',
      title: 'Flutter Belgium #2',
      date: DateTime(2024, 2, 22),
      hostCompany: 'Zimmo',
      location: 'Antwerp',
      thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif',
    ),
  ];

  testComponents('PastMeetupsSection renders a card per meetup',
      (tester) async {
    tester.pumpComponent(PastMeetupsSection(meetups: meetups));
    expect(find.tag('img'), findsNComponents(2));
  });

  testComponents('PastMeetupsSection cards link to meetup detail page',
      (tester) async {
    tester.pumpComponent(PastMeetupsSection(meetups: meetups));
    expect(find.text('flutter-belgium-1', findRichText: true), findsNothing);
    // Cards link to /meetups/:slug — verify <a> tags are present (2 cards + 1 view all)
    expect(find.tag('a'), findsNComponents(3));
  });
}
```

- [ ] **Step 2: Update NextMeetupSection tests**

Add to `test/components/next_meetup_section_test.dart` (read the file first):

```bash
cat test/components/next_meetup_section_test.dart
```

Then add a test verifying the "View all upcoming" link:

```dart
testComponents('NextMeetupSection renders View all upcoming link',
    (tester) async {
  tester.pumpComponent(NextMeetupSection(
    meetup: Meetup(
      id: '1',
      title: 'Flutter Belgium #27',
      date: DateTime(2026, 9, 19),
      hostCompany: 'Cronos',
      location: 'Leuven',
    ),
    communityLinks: const CommunityLinks(
      slackInviteUrl: 'https://slack.com',
      youtubeChannelUrl: 'https://youtube.com',
      meetupUrl: 'https://meetup.com',
      linkedinUrl: 'https://linkedin.com',
      githubUrl: 'https://github.com',
      madeInUrl: '/made-in-flutter-belgium/apps',
    ),
  ));
  expect(find.text('View all upcoming →', findRichText: true), findsOneComponent);
});
```

- [ ] **Step 3: Run to verify failure**

```bash
dart test test/components/past_meetups_section_test.dart test/components/next_meetup_section_test.dart
```

Expected: failures — `meetupGroupUrl` required, "View all upcoming" not found.

- [ ] **Step 4: Update PastMeetupsSection**

```dart
// lib/components/past_meetups_section.dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/meetup.dart';

class PastMeetupsSection extends StatelessComponent {
  const PastMeetupsSection({required this.meetups, super.key});

  final List<Meetup> meetups;

  @override
  Component build(BuildContext context) {
    return section(classes: 'past-meetups', [
      div(classes: 'past-meetups-inner', [
        const p(classes: 'section-label', [Component.text('Past meetups')]),
        const h2(classes: 'section-title', [Component.text("Where we've been")]),
        div(classes: 'meetups-grid', [
          for (final meetup in meetups) _MeetupCard(meetup: meetup),
        ]),
        a(
          [const Component.text('View all meetups →')],
          href: '/meetups/past',
          classes: 'view-all-link',
        ),
      ]),
    ]);
  }
}

class _MeetupCard extends StatelessComponent {
  const _MeetupCard({required this.meetup});

  final Meetup meetup;

  @override
  Component build(BuildContext context) {
    return a(
      [
        if (meetup.thumbnailUrl != null)
          img(
            src: meetup.thumbnailUrl!,
            alt:
                '${meetup.title}, ${_formatDate(meetup.date)}, ${meetup.hostCompany}, ${meetup.location}',
            classes: 'meetup-card-thumbnail',
          ),
        div(classes: 'meetup-card-body', [
          p(classes: 'meetup-card-date',
              [Component.text(_formatDate(meetup.date))]),
          p(classes: 'meetup-card-title', [Component.text(meetup.title)]),
          p(classes: 'meetup-card-host',
              [Component.text('${meetup.hostCompany} · ${meetup.location}')]),
        ]),
      ],
      href: '/meetups/${meetup.slug}',
      classes: 'meetup-card',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
```

- [ ] **Step 5: Update NextMeetupSection — add "View all upcoming" link**

In `lib/components/next_meetup_section.dart`, add after the sign-up button `div(classes: 'hero-actions', [...])`:

```dart
a(
  [const Component.text('View all upcoming →')],
  href: '/meetups/upcoming',
  classes: 'view-all-link view-all-link-light',
),
```

- [ ] **Step 6: Update HomePage — remove meetupGroupUrl from PastMeetupsSection call**

In `lib/pages/home_page.dart`, update the `PastMeetupsSection` call:

```dart
PastMeetupsSection(meetups: pastMeetups),
```

- [ ] **Step 7: Update main.server.dart — pass trimmed lists to home page**

In `lib/main.server.dart`, update the calls and fetch:

```dart
final upcomingMeetups = await repository.getUpcomingMeetups();
final pastMeetups = await repository.getPastMeetups();
// ... (talks fetch stays as getAllTalks())
```

In the `HomePage(...)` builder:

```dart
nextMeetup: upcomingMeetups.isEmpty ? null : upcomingMeetups.first,
pastMeetups: pastMeetups.take(3).toList(),
talks: talks.take(3).toList(),
```

Remove the old `getNextMeetup()` call.

- [ ] **Step 8: Add CSS for view-all-link**

In `web/styles.css`, add after the `.btn` block:

```css
.view-all-link {
  display: inline-block;
  margin-top: 1.5rem;
  color: var(--color-sky);
  font-weight: 600;
  font-size: 0.95rem;
  text-decoration: none;
  transition: opacity 0.2s;
}

.view-all-link:hover {
  opacity: 0.75;
}

.view-all-link-light {
  color: var(--color-white);
}
```

- [ ] **Step 9: Run all tests**

```bash
dart test
```

Expected: All pass.

- [ ] **Step 10: Commit**

```bash
git add lib/components/past_meetups_section.dart lib/components/next_meetup_section.dart lib/pages/home_page.dart lib/main.server.dart web/styles.css test/components/past_meetups_section_test.dart test/components/next_meetup_section_test.dart
git commit -m "feat: home page teasers link to meetup/talk pages; add View all links"
```

---

## Task 7: MeetupPageShell component + CSS

**Files:**
- Create: `lib/components/meetups/meetup_page_shell.dart`
- Modify: `web/styles.css`

- [ ] **Step 1: Create MeetupPageShell**

```dart
// lib/components/meetups/meetup_page_shell.dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

enum MeetupTab { upcoming, past }

class MeetupPageShell extends StatelessComponent {
  const MeetupPageShell({
    required this.activeTab,
    required this.child,
    super.key,
  });

  final MeetupTab activeTab;
  final List<Component> child;

  @override
  Component build(BuildContext context) {
    return section(classes: 'meetup-list-page', [
      div(classes: 'meetup-list-page-inner', [
        const p(classes: 'section-label', [Component.text('Meetups')]),
        const h1(
            classes: 'section-title',
            [Component.text('Flutter Belgium Meetups')]),
        div(classes: 'hero-actions meetup-tabs', [
          a(
            [const Component.text('upcoming')],
            href: '/meetups/upcoming',
            classes: activeTab == MeetupTab.upcoming
                ? 'btn btn-primary'
                : 'btn btn-secondary',
          ),
          a(
            [const Component.text('past')],
            href: '/meetups/past',
            classes: activeTab == MeetupTab.past
                ? 'btn btn-primary'
                : 'btn btn-secondary',
          ),
        ]),
        div(classes: 'meetup-list-content', child),
      ]),
    ]);
  }
}
```

- [ ] **Step 2: Add meetup list page CSS**

In `web/styles.css`, add after the `.made-in-page` block (or at the end of the file before the responsive section):

```css
/* ── Meetup list pages ─────────────────────────────────────── */
.meetup-list-page {
  padding: var(--section-padding);
  background: var(--color-white);
}

.meetup-list-page-inner {
  max-width: var(--container-max);
  margin: 0 auto;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 1rem;
}

.meetup-tabs {
  margin-top: 0.5rem;
}

.meetup-list-content {
  width: 100%;
  margin-top: 2rem;
  text-align: left;
}
```

- [ ] **Step 3: Commit**

```bash
git add lib/components/meetups/meetup_page_shell.dart web/styles.css
git commit -m "feat: add MeetupPageShell tab component and CSS"
```

---

## Task 8: Meetup list pages (upcoming and past)

**Files:**
- Create: `lib/pages/meetups/meetups_upcoming_page.dart`
- Create: `lib/pages/meetups/meetups_past_page.dart`
- Create: `test/components/meetups_upcoming_page_test.dart`
- Create: `test/components/meetups_past_page_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/components/meetups_upcoming_page_test.dart
import 'package:flutter_belgium_website/components/meetups/meetup_page_shell.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/pages/meetups/meetups_upcoming_page.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const links = CommunityLinks(
    slackInviteUrl: 'https://slack.com',
    youtubeChannelUrl: 'https://youtube.com',
    meetupUrl: 'https://meetup.com',
    linkedinUrl: 'https://linkedin.com',
    githubUrl: 'https://github.com',
    madeInUrl: '/made-in-flutter-belgium/apps',
  );

  final meetups = [
    Meetup(
      id: '1',
      title: 'Flutter Belgium #27',
      date: DateTime(2026, 9, 1),
      hostCompany: 'Cronos',
      location: 'Leuven',
      thumbnailUrl: '/assets/meetup/meetup.avif',
    ),
  ];

  testComponents('MeetupsUpcomingPage renders meetup cards', (tester) async {
    tester.pumpComponent(
        MeetupsUpcomingPage(meetups: meetups, communityLinks: links));
    expect(find.tag('img'), findsOneComponent);
  });

  testComponents('MeetupsUpcomingPage shows "upcoming" tab as active',
      (tester) async {
    tester.pumpComponent(
        MeetupsUpcomingPage(meetups: meetups, communityLinks: links));
    expect(find.classes('btn-primary'), findsOneComponent);
  });
}
```

```dart
// test/components/meetups_past_page_test.dart
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/pages/meetups/meetups_past_page.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const links = CommunityLinks(
    slackInviteUrl: 'https://slack.com',
    youtubeChannelUrl: 'https://youtube.com',
    meetupUrl: 'https://meetup.com',
    linkedinUrl: 'https://linkedin.com',
    githubUrl: 'https://github.com',
    madeInUrl: '/made-in-flutter-belgium/apps',
  );

  testComponents('MeetupsPastPage renders empty state when no past meetups',
      (tester) async {
    tester.pumpComponent(
        MeetupsPastPage(meetups: const [], communityLinks: links));
    expect(find.tag('img'), findsNothing);
  });

  testComponents('MeetupsPastPage renders a card per meetup', (tester) async {
    final meetups = [
      Meetup(
        id: '1',
        title: 'Flutter Belgium #26',
        date: DateTime(2026, 2, 3),
        hostCompany: 'ACA Group',
        location: 'Gent',
        thumbnailUrl: '/assets/meetup/meetup.avif',
      ),
      Meetup(
        id: '2',
        title: 'Flutter Belgium #25',
        date: DateTime(2025, 10, 8),
        hostCompany: 'icapps',
        location: 'Antwerp',
        thumbnailUrl: '/assets/meetup/meetup.avif',
      ),
    ];
    tester.pumpComponent(MeetupsPastPage(meetups: meetups, communityLinks: links));
    expect(find.tag('img'), findsNComponents(2));
  });
}
```

- [ ] **Step 2: Run to verify failure**

```bash
dart test test/components/meetups_upcoming_page_test.dart test/components/meetups_past_page_test.dart
```

Expected: compile error — page files not found.

- [ ] **Step 3: Create MeetupsUpcomingPage**

```dart
// lib/pages/meetups/meetups_upcoming_page.dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/meetups/meetup_page_shell.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/util/string_utils.dart';

class MeetupsUpcomingPage extends StatelessComponent {
  const MeetupsUpcomingPage({
    required this.meetups,
    required this.communityLinks,
    super.key,
  });

  final List<Meetup> meetups;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      MeetupPageShell(
        activeTab: MeetupTab.upcoming,
        child: [
          if (meetups.isEmpty)
            p(classes: 'no-meetup-message', [
              const Component.text(
                  'No upcoming meetups scheduled yet. Follow us on Slack to stay updated.'),
            ])
          else
            div(classes: 'meetups-grid', [
              for (final meetup in meetups)
                _MeetupListCard(meetup: meetup),
            ]),
        ],
      ),
      Footer(communityLinks: communityLinks),
    ]);
  }
}

class _MeetupListCard extends StatelessComponent {
  const _MeetupListCard({required this.meetup});

  final Meetup meetup;

  @override
  Component build(BuildContext context) {
    return a(
      [
        if (meetup.thumbnailUrl != null)
          img(
            src: meetup.thumbnailUrl!,
            alt:
                '${meetup.title}, ${_formatDate(meetup.date)}, ${meetup.hostCompany}, ${meetup.location}',
            classes: 'meetup-card-thumbnail',
          ),
        div(classes: 'meetup-card-body', [
          p(classes: 'meetup-card-date',
              [Component.text(_formatDate(meetup.date))]),
          p(classes: 'meetup-card-title', [Component.text(meetup.title)]),
          p(classes: 'meetup-card-host',
              [Component.text('${meetup.hostCompany} · ${meetup.location}')]),
        ]),
      ],
      href: '/meetups/${meetup.slug}',
      classes: 'meetup-card',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
```

- [ ] **Step 4: Create MeetupsPastPage**

```dart
// lib/pages/meetups/meetups_past_page.dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/meetups/meetup_page_shell.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';

class MeetupsPastPage extends StatelessComponent {
  const MeetupsPastPage({
    required this.meetups,
    required this.communityLinks,
    super.key,
  });

  final List<Meetup> meetups;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      MeetupPageShell(
        activeTab: MeetupTab.past,
        child: [
          if (meetups.isEmpty)
            const p(classes: 'no-meetup-message',
                [Component.text('No past meetups yet.')])
          else
            div(classes: 'meetups-grid', [
              for (final meetup in meetups)
                _MeetupListCard(meetup: meetup),
            ]),
        ],
      ),
      Footer(communityLinks: communityLinks),
    ]);
  }
}

class _MeetupListCard extends StatelessComponent {
  const _MeetupListCard({required this.meetup});

  final Meetup meetup;

  @override
  Component build(BuildContext context) {
    return a(
      [
        if (meetup.thumbnailUrl != null)
          img(
            src: meetup.thumbnailUrl!,
            alt:
                '${meetup.title}, ${_formatDate(meetup.date)}, ${meetup.hostCompany}, ${meetup.location}',
            classes: 'meetup-card-thumbnail',
          ),
        div(classes: 'meetup-card-body', [
          p(classes: 'meetup-card-date',
              [Component.text(_formatDate(meetup.date))]),
          p(classes: 'meetup-card-title', [Component.text(meetup.title)]),
          p(classes: 'meetup-card-host',
              [Component.text('${meetup.hostCompany} · ${meetup.location}')]),
        ]),
      ],
      href: '/meetups/${meetup.slug}',
      classes: 'meetup-card',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
```

- [ ] **Step 5: Run tests**

```bash
dart test test/components/meetups_upcoming_page_test.dart test/components/meetups_past_page_test.dart
```

Expected: All pass.

- [ ] **Step 6: Run all tests**

```bash
dart test
```

Expected: All pass.

- [ ] **Step 7: Commit**

```bash
git add lib/pages/meetups/meetups_upcoming_page.dart lib/pages/meetups/meetups_past_page.dart test/components/meetups_upcoming_page_test.dart test/components/meetups_past_page_test.dart
git commit -m "feat: add MeetupsUpcomingPage and MeetupsPastPage"
```

---

## Task 9: Meetup detail page

**Files:**
- Create: `lib/pages/meetups/meetup_detail_page.dart`
- Create: `test/components/meetup_detail_page_test.dart`
- Modify: `web/styles.css`

- [ ] **Step 1: Write failing tests**

```dart
// test/components/meetup_detail_page_test.dart
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/pages/meetups/meetup_detail_page.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const links = CommunityLinks(
    slackInviteUrl: 'https://slack.com',
    youtubeChannelUrl: 'https://youtube.com',
    meetupUrl: 'https://meetup.com',
    linkedinUrl: 'https://linkedin.com',
    githubUrl: 'https://github.com',
    madeInUrl: '/made-in-flutter-belgium/apps',
  );

  const speaker = Person(
    id: 'p1',
    name: 'Jane Doe',
    avatarUrl: '/avatar.jpg',
    companies: [
      PersonCompany(name: 'Acme', jobTitle: 'Flutter Dev', isActive: true)
    ],
    socialLinks: PersonSocialLinks(),
  );

  final upcomingMeetup = Meetup(
    id: 'm1',
    title: 'Flutter Belgium #27',
    date: DateTime(2099, 9, 1),
    hostCompany: 'Cronos',
    location: 'Leuven',
    description: 'A great event.',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/123',
  );

  final pastMeetup = Meetup(
    id: 'm2',
    title: 'Flutter Belgium #26',
    date: DateTime(2020, 2, 3),
    hostCompany: 'ACA',
    location: 'Gent',
  );

  final talkWithVideo = Talk(
    id: 't1',
    title: 'Building reactive UIs',
    date: DateTime(2099, 9, 1),
    youtubeUrl: 'https://www.youtube.com/watch?v=abc123',
    meetupId: 'm1',
    speakers: [speaker],
  );

  final talkNoVideo = Talk(
    id: 't2',
    title: 'No Video Yet',
    date: DateTime(2099, 9, 1),
    meetupId: 'm1',
    speakers: [speaker],
  );

  testComponents('MeetupDetailPage renders meetup title', (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetup,
      talks: [talkWithVideo],
      communityLinks: links,
    ));
    expect(find.text('Flutter Belgium #27', findRichText: true),
        findsOneComponent);
  });

  testComponents(
      'MeetupDetailPage shows sign-up button for upcoming meetup with meetupUrl',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetup,
      talks: [],
      communityLinks: links,
    ));
    expect(find.text('Sign up for this event', findRichText: true),
        findsOneComponent);
  });

  testComponents(
      'MeetupDetailPage hides sign-up button for past meetup',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: pastMeetup,
      talks: [],
      communityLinks: links,
    ));
    expect(find.text('Sign up for this event', findRichText: true),
        findsNothing);
  });

  testComponents('MeetupDetailPage hides talks section when no talks',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetup,
      talks: [],
      communityLinks: links,
    ));
    expect(find.text('Talks', findRichText: true), findsNothing);
  });

  testComponents('MeetupDetailPage shows talk title for talk with video',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetup,
      talks: [talkWithVideo],
      communityLinks: links,
    ));
    expect(find.text('Building reactive UIs', findRichText: true),
        findsOneComponent);
  });

  testComponents('MeetupDetailPage shows coming soon placeholder for talk without video',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetup,
      talks: [talkNoVideo],
      communityLinks: links,
    ));
    expect(find.text('Video coming soon', findRichText: true), findsOneComponent);
  });
}
```

- [ ] **Step 2: Run to verify failure**

```bash
dart test test/components/meetup_detail_page_test.dart
```

Expected: compile error — `meetup_detail_page.dart` not found.

- [ ] **Step 3: Create MeetupDetailPage**

```dart
// lib/pages/meetups/meetup_detail_page.dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';

class MeetupDetailPage extends StatelessComponent {
  const MeetupDetailPage({
    required this.meetup,
    required this.talks,
    required this.communityLinks,
    super.key,
  });

  final Meetup meetup;
  final List<Talk> talks;
  final CommunityLinks communityLinks;

  bool get _isUpcoming => meetup.date.isAfter(DateTime.now());

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      _MeetupDetailHero(
        meetup: meetup,
        showSignUp: _isUpcoming && meetup.meetupUrl != null,
      ),
      if (talks.isNotEmpty)
        _MeetupDetailTalks(talks: talks),
      Footer(communityLinks: communityLinks),
    ]);
  }
}

class _MeetupDetailHero extends StatelessComponent {
  const _MeetupDetailHero({
    required this.meetup,
    required this.showSignUp,
  });

  final Meetup meetup;
  final bool showSignUp;

  @override
  Component build(BuildContext context) {
    return section(classes: 'next-meetup', [
      div(classes: 'next-meetup-inner', [
        p(classes: 'meetup-detail-meta', [
          Component.text(
              '${_formatDate(meetup.date)} · ${meetup.location} · Hosted by ${meetup.hostCompany}'),
        ]),
        h1(classes: 'section-title', [Component.text(meetup.title)]),
        if (meetup.thumbnailUrl != null)
          img(
            src: meetup.thumbnailUrl!,
            alt: meetup.title,
            classes: 'next-meetup-thumbnail',
          ),
        if (meetup.description != null)
          p(classes: 'meetup-detail-description',
              [Component.text(meetup.description!)]),
        if (showSignUp)
          div(classes: 'hero-actions', [
            a(
              [const Component.text('Sign up for this event')],
              href: meetup.meetupUrl!,
              classes: 'btn btn-outline-white',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            ),
          ]),
      ]),
    ]);
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _MeetupDetailTalks extends StatelessComponent {
  const _MeetupDetailTalks({required this.talks});

  final List<Talk> talks;

  @override
  Component build(BuildContext context) {
    return section(classes: 'talks', [
      div(classes: 'talks-inner', [
        const p(classes: 'section-label', [Component.text('Talks')]),
        const h2(classes: 'section-title',
            [Component.text('Catch up on what you missed')]),
        div(classes: 'talks-grid', [
          for (final talk in talks) _MeetupTalkCard(talk: talk),
        ]),
      ]),
    ]);
  }
}

class _MeetupTalkCard extends StatelessComponent {
  const _MeetupTalkCard({required this.talk});

  final Talk talk;

  @override
  Component build(BuildContext context) {
    final card = article(classes: 'talk-card meetup-detail-talk-card', [
      if (talk.thumbnailUrl != null)
        img(
          src: talk.thumbnailUrl!,
          alt: talk.title,
          classes: 'talk-thumbnail',
        )
      else
        div(classes: 'talk-thumbnail-placeholder', [
          const Component.text('Video coming soon'),
        ]),
      div(classes: 'meetup-talk-info', [
        p(classes: 'meetup-talk-title', [Component.text(talk.title)]),
        for (final speaker in talk.speakers)
          div(classes: 'meetup-talk-speaker', [
            img(
              src: speaker.avatarUrl,
              alt: speaker.name,
              classes: 'meetup-talk-speaker-avatar',
            ),
            p(classes: 'meetup-talk-speaker-name', [
              Component.text(speaker.activeCompany != null
                  ? '${speaker.name} · ${speaker.activeCompany!.name}'
                  : speaker.name),
            ]),
          ]),
      ]),
    ]);

    if (talk.youtubeUrl != null) {
      return a(
        [card],
        href: talk.youtubeUrl!,
        classes: 'talk-link',
        target: Target.blank,
        attributes: {'rel': 'noopener noreferrer'},
      );
    }
    return card;
  }
}
```

- [ ] **Step 4: Add CSS for meetup detail talk cards**

In `web/styles.css`, add:

```css
/* ── Meetup detail talk cards ──────────────────────────────── */
.meetup-detail-talk-card {
  display: flex;
  flex-direction: column;
}

.talk-thumbnail-placeholder {
  width: 100%;
  aspect-ratio: 16 / 9;
  background: var(--color-grey);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 0.75rem;
  color: var(--color-navy);
  opacity: 0.5;
  border-radius: 8px 8px 0 0;
}

.meetup-talk-info {
  padding: 0.6rem 0.75rem 0.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.meetup-talk-title {
  font-weight: 700;
  font-size: 0.85rem;
  color: var(--color-navy);
  line-height: 1.3;
  margin: 0;
}

.meetup-talk-speaker {
  display: flex;
  align-items: center;
  gap: 0.4rem;
}

.meetup-talk-speaker-avatar {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  object-fit: cover;
  flex-shrink: 0;
}

.meetup-talk-speaker-name {
  font-size: 0.72rem;
  color: var(--color-navy);
  opacity: 0.65;
  margin: 0;
}

.meetup-detail-meta {
  font-size: 0.8rem;
  color: var(--color-white);
  opacity: 0.8;
  margin-bottom: 0.5rem;
}

.meetup-detail-description {
  font-size: 0.9rem;
  color: var(--color-white);
  opacity: 0.8;
  max-width: 560px;
  text-align: center;
  line-height: 1.6;
}
```

- [ ] **Step 5: Run tests**

```bash
dart test test/components/meetup_detail_page_test.dart
```

Expected: All pass.

- [ ] **Step 6: Run all tests**

```bash
dart test
```

Expected: All pass.

- [ ] **Step 7: Commit**

```bash
git add lib/pages/meetups/meetup_detail_page.dart test/components/meetup_detail_page_test.dart web/styles.css
git commit -m "feat: add MeetupDetailPage with hero, sign-up button, and related talks"
```

---

## Task 10: Talks list page

**Files:**
- Create: `lib/pages/talks/talks_page.dart`
- Create: `test/components/talks_page_test.dart`

- [ ] **Step 1: Write failing tests**

```dart
// test/components/talks_page_test.dart
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/pages/talks/talks_page.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const links = CommunityLinks(
    slackInviteUrl: 'https://slack.com',
    youtubeChannelUrl: 'https://youtube.com',
    meetupUrl: 'https://meetup.com',
    linkedinUrl: 'https://linkedin.com',
    githubUrl: 'https://github.com',
    madeInUrl: '/made-in-flutter-belgium/apps',
  );

  const talkWithVideo = Talk(
    id: 't1',
    title: 'Test Talk',
    date: DateTime(2026, 2, 1),
    youtubeUrl: 'https://youtube.com/watch?v=abc',
    meetupId: 'm1',
    speakers: [],
  );
  const talkNoVideo = Talk(
    id: 't2',
    title: 'No Video',
    date: DateTime(2026, 1, 1),
    meetupId: 'm1',
    speakers: [],
  );

  testComponents('TalksPage renders one card per talk with video',
      (tester) async {
    tester.pumpComponent(
        TalksPage(talks: [talkWithVideo, talkWithVideo], communityLinks: links));
    expect(find.tag('img'), findsNComponents(2));
  });

  testComponents('TalksPage skips talks without a YouTube URL',
      (tester) async {
    tester.pumpComponent(
        TalksPage(talks: [talkWithVideo, talkNoVideo], communityLinks: links));
    expect(find.tag('img'), findsOneComponent);
  });

  testComponents('TalksPage each video card links to YouTube', (tester) async {
    tester.pumpComponent(
        TalksPage(talks: [talkWithVideo], communityLinks: links));
    expect(find.tag('a'), findsOneComponent);
  });
}
```

- [ ] **Step 2: Run to verify failure**

```bash
dart test test/components/talks_page_test.dart
```

Expected: compile error — `talks_page.dart` not found.

- [ ] **Step 3: Create TalksPage**

```dart
// lib/pages/talks/talks_page.dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/components/talks_section.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';

class TalksPage extends StatelessComponent {
  const TalksPage({
    required this.talks,
    required this.communityLinks,
    super.key,
  });

  final List<Talk> talks;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      _TalksPageBody(talks: talks),
      Footer(communityLinks: communityLinks),
    ]);
  }
}

class _TalksPageBody extends StatelessComponent {
  const _TalksPageBody({required this.talks});

  final List<Talk> talks;

  @override
  Component build(BuildContext context) {
    final withVideo = talks.where((t) => t.youtubeUrl != null).toList();
    return section(classes: 'talks', [
      div(classes: 'talks-inner', [
        const p(classes: 'section-label', [Component.text('Talks')]),
        const h1(classes: 'section-title',
            [Component.text('Catch up on what you missed')]),
        div(classes: 'talks-grid', [
          for (final talk in withVideo)
            a(
              [
                article(classes: 'talk-card', [
                  img(
                    src: talk.thumbnailUrl!,
                    alt: talk.title,
                    classes: 'talk-thumbnail',
                  ),
                ]),
              ],
              href: talk.youtubeUrl!,
              classes: 'talk-link',
              target: Target.blank,
              attributes: {'rel': 'noopener noreferrer'},
            ),
        ]),
      ]),
    ]);
  }
}
```

- [ ] **Step 4: Run tests**

```bash
dart test test/components/talks_page_test.dart
```

Expected: All pass.

- [ ] **Step 5: Run all tests**

```bash
dart test
```

Expected: All pass.

- [ ] **Step 6: Commit**

```bash
git add lib/pages/talks/talks_page.dart test/components/talks_page_test.dart
git commit -m "feat: add TalksPage at /talks"
```

---

## Task 11: Wire routes in main.server.dart

**Files:**
- Modify: `lib/main.server.dart`

- [ ] **Step 1: Update main.server.dart**

Add imports:

```dart
import 'package:flutter_belgium_website/pages/meetups/meetup_detail_page.dart';
import 'package:flutter_belgium_website/pages/meetups/meetups_past_page.dart';
import 'package:flutter_belgium_website/pages/meetups/meetups_upcoming_page.dart';
import 'package:flutter_belgium_website/pages/talks/talks_page.dart';
```

Update data fetching (after `repository` is created):

```dart
final upcomingMeetups = await repository.getUpcomingMeetups();
final pastMeetups = await repository.getPastMeetups();
final allMeetups = [...upcomingMeetups, ...pastMeetups];
final talks = await repository.getAllTalks();
final communityLinks = await repository.getCommunityLinks();
final companies = await repository.getHostingCompanies();
final testimonials = shuffleNoAdjacentDuplicates(
  await repository.getTestimonials(),
  (t) => t.author.name,
);
final teamMembers = await repository.getTeamMembers();
final sponsors = await repository.getSponsors();
```

Update `HomePage` builder:

```dart
builder: (context, state) => HomePage(
  nextMeetup: upcomingMeetups.isEmpty ? null : upcomingMeetups.first,
  pastMeetups: pastMeetups.take(3).toList(),
  talks: talks.take(3).toList(),
  communityLinks: communityLinks,
  companies: companies,
  testimonials: testimonials,
  members: teamMembers,
  sponsors: sponsors,
  latestMadeInApps: latestApps,
),
```

Add the four new routes (place them before the Made In routes):

```dart
Route(
  path: '/meetups/upcoming',
  title: 'Upcoming Meetups | Flutter Belgium',
  settings: const RouteSettings(changeFreq: ChangeFreq.weekly, priority: 0.9),
  builder: (context, state) => MeetupsUpcomingPage(
    meetups: upcomingMeetups,
    communityLinks: communityLinks,
  ),
),
Route(
  path: '/meetups/past',
  title: 'Past Meetups | Flutter Belgium',
  settings: const RouteSettings(changeFreq: ChangeFreq.monthly, priority: 0.8),
  builder: (context, state) => MeetupsPastPage(
    meetups: pastMeetups,
    communityLinks: communityLinks,
  ),
),
for (final meetup in allMeetups)
  Route(
    path: '/meetups/${meetup.slug}',
    title: '${meetup.title} | Flutter Belgium',
    settings: const RouteSettings(changeFreq: ChangeFreq.monthly, priority: 0.8),
    builder: (context, state) => MeetupDetailPage(
      meetup: meetup,
      talks: talks.where((t) => t.meetupId == meetup.id).toList(),
      communityLinks: communityLinks,
    ),
  ),
Route(
  path: '/talks',
  title: 'Talks | Flutter Belgium',
  settings: const RouteSettings(changeFreq: ChangeFreq.weekly, priority: 0.8),
  builder: (context, state) => TalksPage(
    talks: talks,
    communityLinks: communityLinks,
  ),
),
```

- [ ] **Step 2: Run all tests**

```bash
dart test
```

Expected: All pass.

- [ ] **Step 3: Build the site to verify static generation works**

```bash
fvm dart run jaspr_cli:jaspr build
```

Expected: Build completes without errors.

- [ ] **Step 4: Commit**

```bash
git add lib/main.server.dart
git commit -m "feat: wire /meetups/upcoming, /meetups/past, /meetups/:slug, /talks routes"
```
