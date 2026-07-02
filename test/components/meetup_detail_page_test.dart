import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/pages/meetups/meetup_detail_page.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

import '../test_data.dart';

void main() {
  const links = testCommunityLinks;

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

  testComponents('MeetupDetailPage shows TBD card for talk without YouTube URL',
      (tester) async {
    tester.pumpComponent(MeetupDetailPage(
      meetup: upcomingMeetupWithTbdTalk,
      communityLinks: links,
    ));
    expect(find.text('TBD'), findsOneComponent);
  });
}
