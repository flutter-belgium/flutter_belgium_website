import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/components/talk_card.dart';
import 'package:flutter_belgium_website/components/tbd_talk_card.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class MeetupDetailPage extends StatelessComponent {
  const MeetupDetailPage({
    required this.meetup,
    required this.communityLinks,
    super.key,
  });

  final Meetup meetup;
  final CommunityLinks communityLinks;

  bool get _isUpcoming => meetup.date.isAfter(DateTime.now());

  List<Component> _buildDescription() {
    final desc = meetup.description;
    if (desc == null) return [];

    final tokenRegex = RegExp(r'<session-(\d+)>');
    final components = <Component>[];
    var lastEnd = 0;

    for (final match in tokenRegex.allMatches(desc)) {
      if (match.start > lastEnd) {
        components.add(Component.text(desc.substring(lastEnd, match.start)));
      }
      final sessionIndex = int.parse(match.group(1)!) - 1;
      String label;
      if (sessionIndex < meetup.talks.length) {
        final talk = meetup.talks[sessionIndex];
        final speakers = talk.speakers.map((sp) => sp.name).join(' & ');
        label = speakers.isEmpty ? talk.title : '${talk.title} — $speakers';
      } else {
        label = 'TBD';
      }
      components.add(b([Component.text(label)]));
      lastEnd = match.end;
    }

    if (lastEnd < desc.length) {
      components.add(Component.text(desc.substring(lastEnd)));
    }

    return components;
  }

  @override
  Component build(BuildContext context) {
    final hasTalksWithVideo = meetup.talks.any((t) => t.thumbnailUrl != null);
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      _MeetupDetailHero(
        meetup: meetup,
        descriptionComponents: _buildDescription(),
        showSignUp: _isUpcoming && meetup.meetupUrl != null,
        showRewatch: !_isUpcoming && hasTalksWithVideo,
      ),
      if (meetup.talks.isNotEmpty) _MeetupDetailTalks(talks: meetup.talks),
      Footer(communityLinks: communityLinks),
    ]);
  }
}

class _MeetupDetailHero extends StatelessComponent {
  const _MeetupDetailHero({
    required this.meetup,
    required this.descriptionComponents,
    required this.showSignUp,
    required this.showRewatch,
  });

  final Meetup meetup;
  final List<Component> descriptionComponents;
  final bool showSignUp;
  final bool showRewatch;

  @override
  Component build(BuildContext context) {
    return section(classes: 'meetup-detail-page', [
      div(classes: 'meetup-detail-page-inner container', [
        div(classes: 'meetup-detail-content', [
          h1(classes: 'meetup-detail-title', [Component.text(meetup.title)]),
          p(classes: 'meetup-detail-host', [
            Component.text('Hosted by ${meetup.hostCompany}'),
          ]),
          if (descriptionComponents.isNotEmpty)
            p(classes: 'meetup-detail-description', descriptionComponents),
        ]),
        div(classes: 'meetup-detail-sidebar', [
          if (meetup.thumbnailUrl != null)
            img(
              src: meetup.thumbnailUrl!,
              alt: meetup.title,
              classes: 'meetup-detail-thumbnail',
            ),
          div(classes: 'meetup-detail-info-card', [
            div(classes: 'meetup-detail-info-row', [
              span(
                  classes: 'meetup-detail-info-icon',
                  [const Component.text('📅')]),
              span(
                  classes: 'meetup-detail-info-text',
                  [Component.text(_formatDate(meetup.date))]),
            ]),
            div(classes: 'meetup-detail-info-row', [
              span(
                  classes: 'meetup-detail-info-icon',
                  [const Component.text('📍')]),
              span(classes: 'meetup-detail-info-text', [
                Component.text('${meetup.hostCompany} · ${meetup.location}')
              ]),
            ]),
            if (showSignUp)
              a(
                [const Component.text('Sign up for this event')],
                href: meetup.meetupUrl!,
                classes: 'btn btn-primary meetup-detail-signup',
                attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
              ),
            if (showRewatch)
              a(
                [const Component.text('Rewatch the talks')],
                href: '/meetups/${meetup.slug}#meetup-talks',
                classes: 'btn btn-secondary meetup-detail-signup',
              ),
          ]),
        ]),
      ]),
    ]);
  }

  String _formatDate(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
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
    final dayName = days[date.weekday - 1];
    return '$dayName, ${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}

class _MeetupDetailTalks extends StatelessComponent {
  const _MeetupDetailTalks({required this.talks});

  final List<Talk> talks;

  @override
  Component build(BuildContext context) {
    return section(id: 'meetup-talks', classes: 'talks', [
      div(classes: 'talks-inner container', [
        const p(classes: 'section-label', [Component.text('Talks')]),
        const h2(
            classes: 'section-title', [Component.text('Rewatch every talk')]),
        div(classes: 'talks-grid', [
          for (final (index, talk) in talks.indexed)
            if (talk.thumbnailUrl != null)
              TalkCard(talk: talk)
            else
              TbdTalkCard(slotNumber: (index % 20) + 1),
        ]),
      ]),
    ]);
  }
}
