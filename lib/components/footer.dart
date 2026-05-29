import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/models/community_links.dart';

class Footer extends StatelessComponent {
  const Footer({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return footer(classes: 'footer', [
      div(classes: 'footer-inner container', [
        const img(src: '/assets/logo-full-white.svg', alt: 'Flutter Belgium', classes: 'footer-logo'),
        nav(classes: 'footer-social', [
          a([const Component.text('Slack')],
              href: communityLinks.slackInviteUrl,
              classes: 'footer-social-link',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'Slack'}),
          a([const Component.text('YouTube')],
              href: communityLinks.youtubeChannelUrl,
              classes: 'footer-social-link',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'YouTube'}),
          a([const Component.text('Meetup')],
              href: communityLinks.meetupUrl,
              classes: 'footer-social-link',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'Meetup'}),
          a([const Component.text('LinkedIn')],
              href: communityLinks.linkedinUrl,
              classes: 'footer-social-link',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'LinkedIn'}),
          a([const Component.text('GitHub')],
              href: communityLinks.githubUrl,
              classes: 'footer-social-link',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'GitHub'}),
          a([const Component.text('Made in Flutter Belgium')],
              href: communityLinks.madeInUrl,
              classes: 'footer-social-link',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': 'Made in Flutter Belgium'}),
        ]),
        div(classes: 'footer-bottom', [
          p(classes: 'footer-copy',
              [Component.text('© 2018–${DateTime.now().year} Flutter Belgium')]),
          nav(classes: 'footer-legal', [
            a([const Component.text('Privacy Policy')],
                href: '/privacy', classes: 'footer-legal-link'),
            a([const Component.text('Terms & Conditions')],
                href: '/terms', classes: 'footer-legal-link'),
            a([const Component.text('Branding')],
                href: '/branding', classes: 'footer-legal-link'),
          ]),
        ]),
      ]),
    ]);
  }
}
