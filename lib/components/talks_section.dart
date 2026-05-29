import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/talk.dart';

class TalksSection extends StatelessComponent {
  const TalksSection({required this.talks, super.key});

  final List<Talk> talks;

  @override
  Component build(BuildContext context) {
    return section(id: 'talks', classes: 'talks', [
      div(classes: 'talks-inner', [
        const p(classes: 'section-label', [Component.text('Talks')]),
        const h2(
            classes: 'section-title',
            [Component.text('Catch up on what you missed')]),
        div(classes: 'talks-grid', [
          for (final talk in talks) _TalkCard(talk: talk),
        ]),
      ]),
    ]);
  }
}

class _TalkCard extends StatelessComponent {
  const _TalkCard({required this.talk});

  final Talk talk;

  @override
  Component build(BuildContext context) {
    return a(
      [
        article(classes: 'talk-card', [
          img(
            src: talk.thumbnailUrl,
            alt: 'Flutter Belgium talk',
            classes: 'talk-thumbnail',
          ),
        ]),
      ],
      href: talk.youtubeUrl,
      classes: 'talk-link',
      target: Target.blank,
      attributes: {'rel': 'noopener noreferrer'},
    );
  }
}
