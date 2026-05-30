import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class JoinSection extends StatelessComponent {
  const JoinSection({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return section(id: 'join', classes: 'join', [
      div(classes: 'join-inner container', [
        const h2(
            classes: 'section-title', [Component.text('Join the community')]),
        const p(classes: 'join-sub', [
          Component.text(
              'Connect with Flutter developers across Belgium. Ask questions, share projects, and be the first to know about upcoming meetups.'),
        ]),
        div(classes: 'join-actions', [
          a(
            [
              img(src: '/assets/icons/slack.svg', alt: '', classes: 'btn-icon'),
              const Component.text('Join us on Slack'),
            ],
            href: communityLinks.slackInviteUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          ),
          a(
            [
              img(
                  src: '/assets/icons/youtube.svg',
                  alt: '',
                  classes: 'btn-icon'),
              const Component.text('YouTube'),
            ],
            href: communityLinks.youtubeChannelUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          ),
          a(
            [
              img(
                  src: '/assets/icons/meetup.svg',
                  alt: '',
                  classes: 'btn-icon'),
              const Component.text('Meetup'),
            ],
            href: communityLinks.meetupUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          ),
          a(
            [
              img(
                  src: '/assets/icons/linkedin.svg',
                  alt: '',
                  classes: 'btn-icon'),
              const Component.text('LinkedIn'),
            ],
            href: communityLinks.linkedinUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          ),
          a(
            [
              img(
                  src: '/assets/icons/github.svg',
                  alt: '',
                  classes: 'btn-icon'),
              const Component.text('GitHub'),
            ],
            href: communityLinks.githubUrl,
            classes: 'btn btn-outline-white',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          ),
        ]),
      ]),
    ]);
  }
}
