import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/meetups/meetup_list_card.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';

class MeetupsPage extends StatelessComponent {
  const MeetupsPage({
    required this.upcomingMeetups,
    required this.pastMeetups,
    required this.communityLinks,
    super.key,
  });

  final List<Meetup> upcomingMeetups;
  final List<Meetup> pastMeetups;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'list-page', [
        div(classes: 'list-page-inner container', [
          const h1(
              classes: 'list-page-tagline',
              [Component.text('Flutter Belgium Meetups')]),
          const p(classes: 'list-page-sub', [
            Component.text(
                'Browse our past and upcoming Flutter Belgium meetup events.'),
          ]),
          div(classes: 'list-page-content', [
            _MeetupsSection(
              title: 'Upcoming meetups',
              meetups: upcomingMeetups,
              emptyMessage:
                  'No meetups planned currently. Follow us on Slack to stay updated.',
            ),
            _MeetupsSection(
              title: 'Past meetups',
              meetups: pastMeetups,
              emptyMessage: '',
            ),
          ]),
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }
}

class _MeetupsSection extends StatelessComponent {
  const _MeetupsSection({
    required this.title,
    required this.meetups,
    required this.emptyMessage,
  });

  final String title;
  final List<Meetup> meetups;
  final String emptyMessage;

  @override
  Component build(BuildContext context) {
    if (meetups.isEmpty && emptyMessage.isEmpty) return Component.fragment([]);
    return div(classes: 'meetups-section', [
      h2(classes: 'meetups-section-title', [Component.text(title)]),
      if (meetups.isEmpty)
        p(classes: 'no-meetup-message', [Component.text(emptyMessage)])
      else
        div(classes: 'meetups-grid', [
          for (final meetup in meetups) MeetupListCard(meetup: meetup),
        ]),
    ]);
  }
}
