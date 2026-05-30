import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/meetup.dart';

class MeetupListCard extends StatelessComponent {
  const MeetupListCard({required this.meetup, super.key});

  final Meetup meetup;

  @override
  Component build(BuildContext context) {
    return a(
      [
        if (meetup.thumbnailUrl != null)
          img(
            src: meetup.thumbnailUrl!,
            alt:
                '${meetup.title}, ${_formatDate(meetup.date)}, ${meetup.hostCompany}, ${meetup.location}',
            classes: 'meetup-card-thumbnail',
          ),
        div(classes: 'meetup-card-body', [
          p(
              classes: 'meetup-card-date',
              [Component.text(_formatDate(meetup.date))]),
          p(classes: 'meetup-card-title', [Component.text(meetup.title)]),
          p(
              classes: 'meetup-card-host',
              [Component.text('${meetup.hostCompany} · ${meetup.location}')]),
        ]),
      ],
      href: '/meetups/${meetup.slug}',
      classes: 'meetup-card',
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
