import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:jaspr_test/jaspr_test.dart';

import '../test_data.dart';

void main() {
  const links = testCommunityLinks;

  testComponents('NavBar renders logo, nav links, and Join Slack CTA',
      (tester) async {
    tester.pumpComponent(NavBar(communityLinks: links));
    expect(find.tag('header'), findsOneComponent);
    // Each link appears in both the desktop nav and the mobile menu.
    expect(find.text('About'), findsNComponents(2));
    expect(find.text('Meetups'), findsNComponents(2));
    expect(find.text('Talks'), findsNComponents(2));
    expect(find.text('Join Flutter Belgium'), findsNComponents(2));
  });
}
