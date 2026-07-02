import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/pages/meetups/meetups_page.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

import '../test_data.dart';

void main() {
  const links = testCommunityLinks;

  final upcoming = Meetup(
    id: '1',
    title: 'Flutter Belgium #27',
    date: DateTime(2099, 9, 1),
    hostCompany: 'Cronos',
    location: 'Leuven',
    thumbnailUrl: '/assets/meetup/meetup.avif',
  );

  final past = Meetup(
    id: '2',
    title: 'Flutter Belgium #26',
    date: DateTime(2026, 2, 3),
    hostCompany: 'ACA Group',
    location: 'Gent',
    thumbnailUrl: '/assets/meetup/meetup.avif',
  );

  testComponents('MeetupsPage renders upcoming and past meetup cards',
      (tester) async {
    tester.pumpComponent(MeetupsPage(
      upcomingMeetups: [upcoming],
      pastMeetups: [past],
      communityLinks: links,
    ));
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('meetup-card-thumbnail') ?? false),
      ),
      findsNComponents(2),
    );
  });

  testComponents('MeetupsPage shows no-meetup message when no upcoming meetups',
      (tester) async {
    tester.pumpComponent(MeetupsPage(
      upcomingMeetups: const [],
      pastMeetups: [past],
      communityLinks: links,
    ));
    expect(
      find.text(
          'No meetups planned currently. Follow us on Slack to stay updated.'),
      findsOneComponent,
    );
  });

  testComponents('MeetupsPage renders section titles', (tester) async {
    tester.pumpComponent(MeetupsPage(
      upcomingMeetups: [upcoming],
      pastMeetups: [past],
      communityLinks: links,
    ));
    expect(find.text('Upcoming meetups'), findsOneComponent);
    expect(find.text('Past meetups'), findsOneComponent);
  });

  testComponents('MeetupsPage hides past section when no past meetups',
      (tester) async {
    tester.pumpComponent(MeetupsPage(
      upcomingMeetups: [upcoming],
      pastMeetups: const [],
      communityLinks: links,
    ));
    expect(find.text('Past meetups'), findsNothing);
  });
}
