import 'package:flutter_belgium_website/components/hero_section.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';
import 'package:jaspr/jaspr.dart';
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

  testComponents('HeroSection renders two-column layout with logomark',
      (tester) async {
    tester.pumpComponent(HeroSection(communityLinks: links));
    expect(find.tag('section'), findsOneComponent);
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent && (c.classes?.contains('hero-content') ?? false),
        description: 'element with class hero-content',
      ),
      findsOneComponent,
    );
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('hero-logomark') ?? false),
        description: 'element with class hero-logomark',
      ),
      findsOneComponent,
    );
    expect(find.text('The Belgian Flutter community'), findsOneComponent);
    expect(find.text('Join our next event'), findsOneComponent);
    expect(find.text('Rewatch a talk'), findsOneComponent);
  });
}
