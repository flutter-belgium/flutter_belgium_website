import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const links = CommunityLinks(
    slackInviteUrl: 'https://join.slack.com/test',
    youtubeChannelUrl: 'https://youtube.com/@test',
    meetupUrl: 'https://meetup.com/test',
    linkedinUrl: 'https://linkedin.com/test',
    githubUrl: 'https://github.com/test',
    madeInUrl: 'https://madein.test',
  );

  testComponents('NavBar renders logo, nav links, and Join Slack CTA',
      (tester) async {
    tester.pumpComponent(NavBar(communityLinks: links));
    expect(find.tag('header'), findsOneComponent);
    expect(find.text('About'), findsOneComponent);
    expect(find.text('Meetups'), findsOneComponent);
    expect(find.text('Talks'), findsOneComponent);
    expect(find.text('Join'), findsOneComponent);
    expect(find.text('Join Slack'), findsOneComponent);
  });
}
