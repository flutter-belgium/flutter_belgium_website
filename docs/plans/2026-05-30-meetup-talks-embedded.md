# Meetup Talks Embedded Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Embed talks directly on `Meetup`, remove `meetupId` from `Talk`, show numbered talk cards (cycling 1–20) and TBD placeholders for talks without a YouTube URL.

**Architecture:** `Meetup.talks` is `List<Talk>` (non-nullable items). A talk with `youtubeUrl == null` is a TBD slot. The description resolver replaces `<session-N>` tokens with bold HTML using Jaspr's `b()` element. `TalkCard` gains a `slotNumber` parameter; a new `TbdTalkCard` handles the no-video case.

**Tech Stack:** Dart 3, Jaspr web framework (`package:jaspr/dom.dart`), `jaspr_test` for component tests.

---

## File Map

| File | Action |
|------|--------|
| `lib/data/models/talk.dart` | Remove `meetupId` |
| `lib/data/models/meetup.dart` | Add `List<Talk> talks` field |
| `lib/data/repositories/flutter_belgium_repository.dart` | Remove `getTalksByMeetupId` |
| `lib/data/repositories/mock_flutter_belgium_repository.dart` | Inline talks into meetups; update `getAllTalks`; remove `_talks` list |
| `lib/components/talk_card.dart` | Add required `slotNumber` param |
| `lib/components/tbd_talk_card.dart` | **Create** TBD placeholder card |
| `lib/pages/meetups/meetup_detail_page.dart` | Remove `talks` param; bold description resolver; all-talks grid with TBD |
| `lib/components/talks_section.dart` | Pass `slotNumber` to `TalkCard` |
| `lib/pages/talks/talks_page.dart` | Pass `slotNumber` to `TalkCard` |
| `lib/main.server.dart` | Remove `talks:` arg from `MeetupDetailPage`; remove `meetupId` filter |
| `test/data/models/models_test.dart` | Remove `meetupId`; add talks default test |
| `test/components/meetup_detail_page_test.dart` | Restructure for embedded talks; update TBD assertion |
| `test/components/talks_section_test.dart` | Remove `meetupId` from Talk ctors |
| `test/components/talks_page_test.dart` | Remove `meetupId` from Talk ctors |

---

### Task 1: Remove `meetupId` from `Talk` model

**Files:**
- Modify: `lib/data/models/talk.dart`
- Modify: `test/data/models/models_test.dart`

- [ ] **Step 1: Update `Talk` model**

Replace the entire file content:

```dart
import 'package:flutter_belgium_website/data/models/person.dart';

class Talk {
  const Talk({
    required this.id,
    required this.title,
    required this.date,
    this.youtubeUrl,
    required this.speakers,
  });

  final String id;
  final String title;
  final DateTime date;
  final String? youtubeUrl;
  final List<Person> speakers;

  String? get thumbnailUrl {
    final videoId = Uri.tryParse(youtubeUrl ?? '')?.queryParameters['v'];
    if (videoId == null || videoId.isEmpty) return null;
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
```

- [ ] **Step 2: Update `models_test.dart` — Talk group**

Replace the `group('Talk', ...)` block:

```dart
group('Talk', () {
  final talk = Talk(
    id: 'talk-1',
    title: 'Building reactive UIs',
    date: DateTime(2026, 2, 3),
    youtubeUrl: 'https://www.youtube.com/watch?v=abc123',
    speakers: const [],
  );

  test('constructs with all fields', () {
    expect(talk.id, 'talk-1');
    expect(talk.title, 'Building reactive UIs');
  });

  test('thumbnailUrl derived from youtubeUrl when present', () {
    expect(talk.thumbnailUrl, contains('abc123'));
  });

  test('thumbnailUrl is null when youtubeUrl is null', () {
    final noVideo = Talk(
      id: 'talk-2',
      title: 'No Video Yet',
      date: DateTime(2026, 2, 3),
      speakers: const [],
    );
    expect(noVideo.thumbnailUrl, isNull);
  });
});
```

- [ ] **Step 3: Run tests**

```
dart test test/data/models/models_test.dart
```

Expected: all Talk group tests pass.

---

### Task 2: Add `talks` to `Meetup` model

**Files:**
- Modify: `lib/data/models/meetup.dart`
- Modify: `test/data/models/models_test.dart`

- [ ] **Step 1: Write a failing test first**

Add to the `group('Meetup', ...)` block in `test/data/models/models_test.dart`:

```dart
test('talks defaults to empty list', () {
  final meetup = Meetup(
    id: '1',
    title: 'Flutter Belgium #1',
    date: DateTime(2024, 3, 14),
    hostCompany: 'iO',
    location: 'Ghent',
  );
  expect(meetup.talks, isEmpty);
});

test('talks contains provided talks', () {
  final talk = Talk(
    id: 't1',
    title: 'A talk',
    date: DateTime(2024, 3, 14),
    speakers: const [],
  );
  final meetup = Meetup(
    id: '1',
    title: 'Flutter Belgium #1',
    date: DateTime(2024, 3, 14),
    hostCompany: 'iO',
    location: 'Ghent',
    talks: [talk],
  );
  expect(meetup.talks, hasLength(1));
  expect(meetup.talks.first.id, 't1');
});
```

- [ ] **Step 2: Run test to verify it fails**

```
dart test test/data/models/models_test.dart
```

Expected: FAIL — `meetup.talks` not defined.

- [ ] **Step 3: Update `Meetup` model**

Replace `lib/data/models/meetup.dart`:

```dart
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/util/string_utils.dart';

class Meetup {
  const Meetup({
    required this.id,
    required this.title,
    required this.date,
    required this.hostCompany,
    required this.location,
    this.talks = const [],
    this.description,
    this.thumbnailUrl,
    this.meetupUrl,
  });

  final String id;
  final String title;
  final DateTime date;
  final String hostCompany;
  final String location;
  final List<Talk> talks;
  final String? description;
  final String? thumbnailUrl;
  final String? meetupUrl;

  String get slug => toSlug(title);
}
```

- [ ] **Step 4: Run tests**

```
dart test test/data/models/models_test.dart
```

Expected: all Meetup group tests pass.

---

### Task 3: Update `MockFlutterBelgiumRepository`

**Files:**
- Modify: `lib/data/repositories/mock_flutter_belgium_repository.dart`

- [ ] **Step 1: Inline talks into meetups and update `getAllTalks`**

In `mock_flutter_belgium_repository.dart`:

1. Replace `static final List<Meetup> _allMeetups` — add `talks:` to each meetup:

```dart
static final List<Meetup> _allMeetups = [
  Meetup(
    id: 'meetup-3',
    title: 'Flutter Belgium #26',
    date: DateTime(2026, 2, 3),
    hostCompany: 'ACA Group',
    location: 'Gent',
    thumbnailUrl: '/assets/meetup/meetup_26.avif',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/312351623',
    talks: [
      Talk(
        id: 'talk-1',
        title: 'Building performant Flutter apps',
        date: DateTime(2026, 2, 3),
        youtubeUrl: 'https://www.youtube.com/watch?v=1bM6JiwLMX0',
        speakers: const [_koen],
      ),
    ],
    description:
        'ACA Group hosts our 26th edition in Gent. An evening packed with Flutter talks, networking, and community vibes. Whether you\'re a seasoned Flutter developer or just getting started, everyone is welcome!\n\nProgram:\n18:00 — Doors open\n18:30 — Lightning Talks\n19:00 — <session-1>\n19:45 — <session-2>\n21:00 — Networking',
  ),
  Meetup(
    id: 'meetup-2',
    title: 'Flutter Belgium #25',
    date: DateTime(2025, 10, 8),
    hostCompany: 'icapps',
    location: 'Antwerp',
    thumbnailUrl: '/assets/meetup/meetup_25.avif',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/306394784',
    talks: [
      Talk(
        id: 'talk-2',
        title: 'State management in 2025',
        date: DateTime(2025, 10, 8),
        youtubeUrl: 'https://www.youtube.com/watch?v=iQQhv72eYRA',
        speakers: const [_jens],
      ),
    ],
    description:
        'icapps welcomes the Flutter Belgium community to Antwerp for our 25th meetup. Expect inspiring talks, good food, and great people. A milestone edition celebrating 25 Flutter Belgium meetups together!\n\nProgram:\n18:00 — Doors open\n18:30 — Lightning Talks\n19:00 — <session-1>\n19:45 — <session-2>\n21:00 — Networking',
  ),
  Meetup(
    id: 'meetup-1',
    title: 'Flutter Belgium #24',
    date: DateTime(2025, 6, 11),
    hostCompany: 'MobileGeneration',
    location: 'Brussels',
    thumbnailUrl: '/assets/meetup/meetup_24.avif',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/306394783',
    talks: [
      Talk(
        id: 'talk-3',
        title: 'Flutter for desktop',
        date: DateTime(2025, 6, 11),
        youtubeUrl: 'https://www.youtube.com/watch?v=J08BJIVDucI',
        speakers: const [_kris],
      ),
    ],
    description:
        'MobileGeneration hosts our summer edition in Brussels. A perfect evening to catch up with the community before the holiday season. Flutter talks, networking, and the usual warm Flutter Belgium atmosphere.\n\nProgram:\n18:00 — Doors open\n18:30 — Lightning Talks\n19:00 — <session-1>\n19:45 — <session-2>\n21:00 — Networking',
  ),
  Meetup(
    id: 'meetup-next',
    title: 'Flutter Belgium #27',
    date: DateTime(2026, 6, 3),
    hostCompany: 'Aaltra',
    location: 'Melle',
    thumbnailUrl: '/assets/meetup/meetup_27.avif',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/314638952',
    description:
        'Aaltra organizes the Flutter Belgium Meetup #27. Are you a Flutter expert or just curious about what Flutter is? Everybody is welcome!\n\nProgram:\n18:00 — Doors open\n18:30 — Lightning Talks\n19:00 — Session 1\n19:45 — Session 2\n21:00 — Networking',
  ),
];
```

2. Remove the `static final List<Talk> _talks = [...]` block entirely.

3. Replace `getAllTalks`:

```dart
@override
Future<List<Talk>> getAllTalks() async {
  final allTalks = _allMeetups.expand((m) => m.talks).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
  return List.unmodifiable(allTalks);
}
```

4. Remove `getTalksByMeetupId` implementation entirely.

- [ ] **Step 2: Run tests**

```
dart test
```

Expected: compile errors on `getTalksByMeetupId` call sites — address in Task 4.

---

### Task 4: Remove `getTalksByMeetupId` from repository interface

**Files:**
- Modify: `lib/data/repositories/flutter_belgium_repository.dart`
- Modify: `lib/main.server.dart`

- [ ] **Step 1: Remove from interface**

In `flutter_belgium_repository.dart`, delete the line:

```dart
Future<List<Talk>> getTalksByMeetupId(String meetupId);
```

- [ ] **Step 2: Remove from `main.server.dart`**

In `lib/main.server.dart`, change the `MeetupDetailPage` route builder from:

```dart
builder: (context, state) => MeetupDetailPage(
  meetup: meetup,
  talks: talks.where((t) => t.meetupId == meetup.id).toList(),
  communityLinks: communityLinks,
),
```

to:

```dart
builder: (context, state) => MeetupDetailPage(
  meetup: meetup,
  communityLinks: communityLinks,
),
```

Also remove the `import 'package:flutter_belgium_website/data/models/talk.dart';` from `main.server.dart` if it is no longer used there (the `talks` variable from `getAllTalks()` still uses it, so keep the import if `talks` is still used for `TalksSection`/`TalksPage`).

- [ ] **Step 3: Run tests**

```
dart test
```

Expected: compile errors on `MeetupDetailPage(talks: ...)` — address in Task 7.

---

### Task 5: Create `TbdTalkCard` component

**Files:**
- Create: `lib/components/tbd_talk_card.dart`

- [ ] **Step 1: Create the component**

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class TbdTalkCard extends StatelessComponent {
  const TbdTalkCard({required this.slotNumber, super.key});

  final int slotNumber;

  @override
  Component build(BuildContext context) {
    return article(classes: 'talk-card talk-card--tbd', [
      div(classes: 'talk-card-slot', [Component.text('Talk $slotNumber')]),
      div(classes: 'talk-card-tbd-label', [
        b([const Component.text('TBD')]),
      ]),
    ]);
  }
}
```

---

### Task 6: Update `TalkCard` — add `slotNumber`

**Files:**
- Modify: `lib/components/talk_card.dart`

- [ ] **Step 1: Add `slotNumber` parameter and slot label**

Replace `lib/components/talk_card.dart`:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/talk.dart';

class TalkCard extends StatelessComponent {
  const TalkCard({required this.talk, required this.slotNumber, super.key});

  final Talk talk;
  final int slotNumber;

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
          div(classes: 'talk-card-slot', [Component.text('Talk $slotNumber')]),
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

---

### Task 7: Update `MeetupDetailPage`

**Files:**
- Modify: `lib/pages/meetups/meetup_detail_page.dart`
- Modify: `test/components/meetup_detail_page_test.dart`

- [ ] **Step 1: Write failing tests**

Replace `test/components/meetup_detail_page_test.dart`:

```dart
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/pages/meetups/meetup_detail_page.dart';
import 'package:jaspr/jaspr.dart';
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

  final talkWithVideo = Talk(
    id: 't1',
    title: 'Building reactive UIs',
    date: DateTime(2099, 9, 1),
    youtubeUrl: 'https://www.youtube.com/watch?v=abc123',
    speakers: const [speaker],
  );

  final talkNoVideo = Talk(
    id: 't2',
    title: 'No Video Yet',
    date: DateTime(2099, 9, 1),
    speakers: const [speaker],
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

  final upcomingMeetupWithTalks = Meetup(
    id: 'm1',
    title: 'Flutter Belgium #27',
    date: DateTime(2099, 9, 1),
    hostCompany: 'Cronos',
    location: 'Leuven',
    description: 'Session: <session-1>',
    meetupUrl: 'https://www.meetup.com/flutter-belgium/events/123',
    talks: [talkWithVideo],
  );

  final upcomingMeetupWithTbdTalk = Meetup(
    id: 'm1',
    title: 'Flutter Belgium #27',
    date: DateTime(2099, 9, 1),
    hostCompany: 'Cronos',
    location: 'Leuven',
    talks: [talkNoVideo],
  );

  final pastMeetup = Meetup(
    id: 'm2',
    title: 'Flutter Belgium #26',
    date: DateTime(2020, 2, 3),
    hostCompany: 'ACA',
    location: 'Gent',
  );

  testComponents('MeetupDetailPage renders meetup title', (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetup,
      communityLinks: links,
    ));
    expect(find.text('Flutter Belgium #27'), findsOneComponent);
  });

  testComponents(
      'MeetupDetailPage shows sign-up button for upcoming meetup with meetupUrl',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetup,
      communityLinks: links,
    ));
    expect(find.text('Sign up for this event'), findsOneComponent);
  });

  testComponents('MeetupDetailPage hides sign-up button for past meetup',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: pastMeetup,
      communityLinks: links,
    ));
    expect(find.text('Sign up for this event'), findsNothing);
  });

  testComponents('MeetupDetailPage hides talks section when no talks',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetup,
      communityLinks: links,
    ));
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent && (c.classes?.contains('talks-inner') ?? false),
      ),
      findsNothing,
    );
  });

  testComponents(
      'MeetupDetailPage resolves session token to bold talk title in description',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetupWithTalks,
      communityLinks: links,
    ));
    expect(find.text('Building reactive UIs — Jane Doe'), findsOneComponent);
  });

  testComponents(
      'MeetupDetailPage shows TBD card for talk without YouTube URL',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetupWithTbdTalk,
      communityLinks: links,
    ));
    expect(find.text('TBD'), findsOneComponent);
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```
dart test test/components/meetup_detail_page_test.dart
```

Expected: compile errors / failures since `MeetupDetailPage` still requires `talks:`.

- [ ] **Step 3: Rewrite `MeetupDetailPage`**

Replace `lib/pages/meetups/meetup_detail_page.dart`:

```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/components/talk_card.dart';
import 'package:flutter_belgium_website/components/tbd_talk_card.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';

class MeetupDetailPage extends StatelessComponent {
  const MeetupDetailPage({
    required this.meetup,
    required this.communityLinks,
    super.key,
  });

  final Meetup meetup;
  final CommunityLinks communityLinks;

  bool get _isUpcoming => meetup.date.isAfter(DateTime.now());

  List<Component> _buildDescription() {
    final desc = meetup.description;
    if (desc == null) return [];

    final tokenRegex = RegExp(r'<session-(\d+)>');
    final components = <Component>[];
    var lastEnd = 0;

    for (final match in tokenRegex.allMatches(desc)) {
      if (match.start > lastEnd) {
        components.add(Component.text(desc.substring(lastEnd, match.start)));
      }
      final sessionIndex = int.parse(match.group(1)!) - 1;
      String label;
      if (sessionIndex < meetup.talks.length) {
        final talk = meetup.talks[sessionIndex];
        final speakers = talk.speakers.map((s) => s.name).join(' & ');
        label = speakers.isEmpty ? talk.title : '${talk.title} — $speakers';
      } else {
        label = 'TBD';
      }
      components.add(b([Component.text(label)]));
      lastEnd = match.end;
    }

    if (lastEnd < desc.length) {
      components.add(Component.text(desc.substring(lastEnd)));
    }

    return components;
  }

  @override
  Component build(BuildContext context) {
    final hasTalksWithVideo = meetup.talks.any((t) => t.thumbnailUrl != null);
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      _MeetupDetailHero(
        meetup: meetup,
        descriptionComponents: _buildDescription(),
        showSignUp: _isUpcoming && meetup.meetupUrl != null,
        showRewatch: !_isUpcoming && hasTalksWithVideo,
      ),
      if (meetup.talks.isNotEmpty) _MeetupDetailTalks(talks: meetup.talks),
      Footer(communityLinks: communityLinks),
    ]);
  }
}

class _MeetupDetailHero extends StatelessComponent {
  const _MeetupDetailHero({
    required this.meetup,
    required this.descriptionComponents,
    required this.showSignUp,
    required this.showRewatch,
  });

  final Meetup meetup;
  final List<Component> descriptionComponents;
  final bool showSignUp;
  final bool showRewatch;

  @override
  Component build(BuildContext context) {
    return section(classes: 'meetup-detail-page', [
      div(classes: 'meetup-detail-page-inner container', [
        div(classes: 'meetup-detail-content', [
          h1(classes: 'meetup-detail-title', [Component.text(meetup.title)]),
          p(classes: 'meetup-detail-host', [
            Component.text('Hosted by ${meetup.hostCompany}'),
          ]),
          if (descriptionComponents.isNotEmpty)
            p(classes: 'meetup-detail-description', descriptionComponents),
        ]),
        div(classes: 'meetup-detail-sidebar', [
          if (meetup.thumbnailUrl != null)
            img(
              src: meetup.thumbnailUrl!,
              alt: meetup.title,
              classes: 'meetup-detail-thumbnail',
            ),
          div(classes: 'meetup-detail-info-card', [
            div(classes: 'meetup-detail-info-row', [
              span(classes: 'meetup-detail-info-icon',
                  [const Component.text('📅')]),
              span(classes: 'meetup-detail-info-text',
                  [Component.text(_formatDate(meetup.date))]),
            ]),
            div(classes: 'meetup-detail-info-row', [
              span(classes: 'meetup-detail-info-icon',
                  [const Component.text('📍')]),
              span(classes: 'meetup-detail-info-text',
                  [Component.text('${meetup.hostCompany} · ${meetup.location}')]),
            ]),
            if (showSignUp)
              a(
                [const Component.text('Sign up for this event')],
                href: meetup.meetupUrl!,
                classes: 'btn btn-primary meetup-detail-signup',
                attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
              ),
            if (showRewatch)
              a(
                [const Component.text('Rewatch the talks')],
                href: '/meetups/${meetup.slug}#meetup-talks',
                classes: 'btn btn-secondary meetup-detail-signup',
              ),
          ]),
        ]),
      ]),
    ]);
  }

  String _formatDate(DateTime date) {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday',
      'Sunday'
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final dayName = days[date.weekday - 1];
    return '$dayName, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _MeetupDetailTalks extends StatelessComponent {
  const _MeetupDetailTalks({required this.talks});

  final List<Talk> talks;

  @override
  Component build(BuildContext context) {
    return section(id: 'meetup-talks', classes: 'talks', [
      div(classes: 'talks-inner container', [
        const p(classes: 'section-label', [Component.text('Talks')]),
        const h2(classes: 'section-title',
            [Component.text('Rewatch every talk')]),
        div(classes: 'talks-grid', [
          for (final (index, talk) in talks.indexed)
            if (talk.thumbnailUrl != null)
              TalkCard(talk: talk, slotNumber: (index % 20) + 1)
            else
              TbdTalkCard(slotNumber: (index % 20) + 1),
        ]),
      ]),
    ]);
  }
}
```

- [ ] **Step 4: Run tests**

```
dart test test/components/meetup_detail_page_test.dart
```

Expected: all 6 tests pass.

---

### Task 8: Update `TalksSection` and `TalksPage`

**Files:**
- Modify: `lib/components/talks_section.dart`
- Modify: `lib/pages/talks/talks_page.dart`
- Modify: `test/components/talks_section_test.dart`
- Modify: `test/components/talks_page_test.dart`

- [ ] **Step 1: Update `TalksSection`**

In `lib/components/talks_section.dart`, change the for loop from:

```dart
for (final talk in withVideo) TalkCard(talk: talk),
```

to:

```dart
for (final (index, talk) in withVideo.indexed)
  TalkCard(talk: talk, slotNumber: (index % 20) + 1),
```

- [ ] **Step 2: Update `TalksPage`**

In `lib/pages/talks/talks_page.dart`, change the for loop from:

```dart
for (final talk in withVideo) TalkCard(talk: talk),
```

to:

```dart
for (final (index, talk) in withVideo.indexed)
  TalkCard(talk: talk, slotNumber: (index % 20) + 1),
```

- [ ] **Step 3: Update `talks_section_test.dart` — remove `meetupId`**

Replace the two Talk constructors at the top of the test:

```dart
final talkWithVideo = Talk(
  id: 't1',
  title: 'Test Talk',
  date: DateTime(2026, 1, 1),
  youtubeUrl: 'https://youtube.com/watch?v=abc',
  speakers: const [],
);
final talkWithoutVideo = Talk(
  id: 't2',
  title: 'No Video',
  date: DateTime(2026, 1, 1),
  speakers: const [],
);
```

- [ ] **Step 4: Update `talks_page_test.dart` — remove `meetupId`**

Replace the two Talk constructors at the top of the test:

```dart
final talkWithVideo = Talk(
  id: 't1',
  title: 'Test Talk',
  date: DateTime(2026, 2, 1),
  youtubeUrl: 'https://youtube.com/watch?v=abc',
  speakers: const [],
);
final talkNoVideo = Talk(
  id: 't2',
  title: 'No Video',
  date: DateTime(2026, 1, 1),
  speakers: const [],
);
```

- [ ] **Step 5: Run tests**

```
dart test test/components/talks_section_test.dart test/components/talks_page_test.dart
```

Expected: all tests pass.

---

### Task 9: Run full test suite

- [ ] **Step 1: Run all tests**

```
dart test
```

Expected: all tests pass with no compile errors or failures.
