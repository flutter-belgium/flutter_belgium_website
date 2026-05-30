import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/meetups/meetup_list_card.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';

class NextMeetupSection extends StatelessComponent {
  const NextMeetupSection({required this.meetups, super.key});

  final List<Meetup> meetups;

  @override
  Component build(BuildContext context) {
    return section(id: 'meetups', classes: 'next-meetup', [
      div(classes: 'next-meetup-inner container', [
        const p(classes: 'section-label', [Component.text('Upcoming')]),
        div(classes: 'section-header-row', [
          const h2(classes: 'section-title',
              [Component.text('Join us at our next event')]),
          a(
            [const Component.text('View all meetups')],
            href: '/meetups',
            classes: 'btn btn-outline-white',
          ),
        ]),
        if (meetups.isEmpty)
          const p(classes: 'no-meetup-message', [
            Component.text(
                'No upcoming meetups scheduled yet. Follow us on Slack to stay updated.'),
          ])
        else
          div(classes: 'meetups-grid', [
            for (final meetup in meetups) MeetupListCard(meetup: meetup),
          ]),
      ]),
    ]);
  }
}
