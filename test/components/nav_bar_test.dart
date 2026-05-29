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
    // Each link appears in both the desktop nav and the mobile menu.
    expect(find.text('About'), findsNComponents(2));
    expect(find.text('Meetups'), findsNComponents(2));
    expect(find.text('Talks'), findsNComponents(2));
    expect(find.text('Join'), findsNComponents(2));
    expect(find.text('Join Slack'), findsNComponents(2));
  });
}
