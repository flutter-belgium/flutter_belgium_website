import 'package:flutter_belgium_website/components/next_meetup_section.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  final meetup = Meetup(
    id: 'next',
    title: 'Flutter Belgium #27',
    date: DateTime(2099, 9, 19),
    hostCompany: 'Cronos',
    location: 'Leuven',
    thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif',
  );

  testComponents('NextMeetupSection renders a card per meetup', (tester) async {
    tester.pumpComponent(NextMeetupSection(meetups: [meetup]));
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('meetup-card-thumbnail') ?? false),
      ),
      findsOneComponent,
    );
  });

  testComponents('NextMeetupSection renders View all meetups button',
      (tester) async {
    tester.pumpComponent(NextMeetupSection(meetups: [meetup]));
    expect(find.text('View all meetups'), findsOneComponent);
  });

  testComponents('NextMeetupSection shows empty state when no meetups',
      (tester) async {
    tester.pumpComponent(const NextMeetupSection(meetups: []));
    expect(
      find.text(
          'No upcoming meetups scheduled yet. Follow us on Slack to stay updated.'),
      findsOneComponent,
    );
  });

  testComponents(
      'NextMeetupSection renders View all meetups link even when no meetups',
      (tester) async {
    tester.pumpComponent(const NextMeetupSection(meetups: []));
    expect(find.text('View all meetups'), findsOneComponent);
  });
}
