import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/models/meetup.dart';

class PastMeetupsSection extends StatelessComponent {
  const PastMeetupsSection(
      {required this.meetups, required this.meetupGroupUrl, super.key});

  final List<Meetup> meetups;
  final String meetupGroupUrl;

  @override
  Component build(BuildContext context) {
    return section(classes: 'past-meetups', [
      div(classes: 'past-meetups-inner', [
        const p(classes: 'section-label', [Component.text('Past meetups')]),
        const h2(
            classes: 'section-title', [Component.text("Where we've been")]),
        div(classes: 'meetups-grid', [
          for (final meetup in meetups)
            _MeetupCard(meetup: meetup, meetupUrl: meetup.meetupUrl ?? meetupGroupUrl),
        ]),
      ]),
    ]);
  }
}

class _MeetupCard extends StatelessComponent {
  const _MeetupCard({required this.meetup, required this.meetupUrl});

  final Meetup meetup;
  final String meetupUrl;

  @override
  Component build(BuildContext context) {
    return a(
      [
        if (meetup.thumbnailUrl != null)
          img(
            src: meetup.thumbnailUrl!,
            alt: '${meetup.title}, ${_formatDate(meetup.date)}, ${meetup.hostCompany}, ${meetup.location}',
            classes: 'meetup-card-thumbnail',
          ),
        div(classes: 'meetup-card-body', [
          p(classes: 'meetup-card-date',
              [Component.text(_formatDate(meetup.date))]),
          p(classes: 'meetup-card-title', [Component.text(meetup.title)]),
          p(classes: 'meetup-card-host',
              [Component.text('${meetup.hostCompany} · ${meetup.location}')]),
        ]),
      ],
      href: meetupUrl,
      classes: 'meetup-card',
      target: Target.blank,
      attributes: {'rel': 'noopener noreferrer'},
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
