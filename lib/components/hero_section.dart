import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/community_links.dart';

class HeroSection extends StatelessComponent {
  const HeroSection({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return section(classes: 'hero', [
      div(classes: 'hero-inner', [
        div(classes: 'hero-content', [
          const h1(
              classes: 'hero-tagline',
              [Component.text('The Belgian Flutter community')]),
          const p(classes: 'hero-sub', [
            Component.text(
                'We bring Flutter developers across Belgium together through meetups, talks, and an active Slack community.'),
          ]),
          div(classes: 'hero-actions', [
            const a([Component.text('Join our next event')],
                href: '#meetups', classes: 'btn btn-primary'),
            const a([Component.text('Rewatch a talk')],
                href: '#talks', classes: 'btn btn-secondary'),
          ]),
          div(classes: 'hero-socials', [
            _socialLink('/assets/icons/slack.svg', 'Slack',
                communityLinks.slackInviteUrl),
            _socialLink('/assets/icons/youtube.svg', 'YouTube',
                communityLinks.youtubeChannelUrl),
            _socialLink(
                '/assets/icons/meetup.svg', 'Meetup', communityLinks.meetupUrl),
            _socialLink('/assets/icons/linkedin.svg', 'LinkedIn',
                communityLinks.linkedinUrl),
            _socialLink(
                '/assets/icons/github.svg', 'GitHub', communityLinks.githubUrl),
          ]),
        ]),
        const div(classes: 'hero-logomark', [
          img(
            src: '/assets/logo-mark.svg',
            alt: 'Flutter Belgium',
          ),
        ]),
      ]),
    ]);
  }

  Component _socialLink(String iconSrc, String label, String href) {
    return a(
      [img(src: iconSrc, alt: label, classes: 'hero-social-icon')],
      href: href,
      classes: 'hero-social-link',
      attributes: {
        'target': '_blank',
        'rel': 'noopener noreferrer',
        'aria-label': label,
      },
    );
  }
}
