import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/models/community_links.dart';
import '../data/models/meetup.dart';

class NextMeetupSection extends StatelessComponent {
  const NextMeetupSection(
      {required this.meetup, required this.communityLinks, super.key});

  final Meetup? meetup;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    final current = meetup;
    return section(id: 'meetups', classes: 'next-meetup', [
      div(classes: 'next-meetup-inner', [
        const h2(
            classes: 'section-title',
            [Component.text('Join us at our next event')]),
        if (current != null) ...[
          if (current.thumbnailUrl != null)
            if (current.meetupUrl != null)
              a(
                [
                  img(
                    src: current.thumbnailUrl!,
                    alt:
                        '${current.title}, ${_formatDate(current.date)}, ${current.hostCompany}, ${current.location}',
                    classes: 'next-meetup-thumbnail',
                  ),
                ],
                href: current.meetupUrl!,
                classes: 'next-meetup-thumbnail-link',
                attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
              )
            else
              img(
                src: current.thumbnailUrl!,
                alt:
                    '${current.title}, ${_formatDate(current.date)}, ${current.hostCompany}, ${current.location}',
                classes: 'next-meetup-thumbnail',
              ),
          div(classes: 'hero-actions', [
            a(
              [const Component.text('Sign up for this event')],
              href: communityLinks.meetupUrl,
              classes: 'btn btn-outline-white',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            ),
          ]),
        ] else
          const p(classes: 'no-meetup-message', [
            Component.text(
                'No upcoming meetup scheduled yet. Follow us on Slack to stay updated.'),
          ]),
      ]),
    ]);
  }

  String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
