import 'package:flutter_belgium_website/components/next_meetup_section.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const links = CommunityLinks(
    slackInviteUrl: 'https://slack.com/invite/test',
    youtubeChannelUrl: 'https://youtube.com/@test',
    meetupUrl: 'https://meetup.com/test',
    linkedinUrl: 'https://linkedin.com/test',
    githubUrl: 'https://github.com/test',
    madeInUrl: 'https://madein.test',
  );

  final meetup = Meetup(
    id: 'next',
    title: 'Flutter Belgium #4',
    date: DateTime(2024, 9, 19),
    hostCompany: 'Cronos',
    location: 'Leuven',
    thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif',
  );

  testComponents('NextMeetupSection shows thumbnail and CTA', (tester) async {
    tester.pumpComponent(
        NextMeetupSection(meetup: meetup, communityLinks: links));
    expect(find.tag('img'), findsOneComponent);
    expect(find.text('Sign up for this event'), findsOneComponent);
  });

  testComponents('NextMeetupSection shows fallback when no meetup',
      (tester) async {
    tester.pumpComponent(
        const NextMeetupSection(meetup: null, communityLinks: links));
    expect(
        find.text(
            'No upcoming meetup scheduled yet. Follow us on Slack to stay updated.'),
        findsOneComponent);
  });
}
