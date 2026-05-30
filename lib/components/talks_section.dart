import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/talk_card.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class TalksSection extends StatelessComponent {
  const TalksSection({required this.talks, super.key});

  final List<Talk> talks;

  @override
  Component build(BuildContext context) {
    final withVideo = talks.where((t) => t.thumbnailUrl != null).toList();
    return section(id: 'talks', classes: 'talks', [
      div(classes: 'talks-inner container', [
        const p(classes: 'section-label', [Component.text('Talks')]),
        div(classes: 'section-header-row', [
          const h2(
              classes: 'section-title',
              [Component.text('Catch up on what you missed')]),
          a(
            [const Component.text('View all talks')],
            href: '/talks',
            classes: 'btn btn-secondary',
          ),
        ]),
        div(classes: 'talks-grid', [
          for (final talk in withVideo) TalkCard(talk: talk),
        ]),
      ]),
    ]);
  }
}
