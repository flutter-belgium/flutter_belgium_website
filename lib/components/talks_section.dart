import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/models/talk.dart';

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
          for (final talk in talks)
            if (talk.youtubeUrl != null && talk.thumbnailUrl != null)
              _TalkCard(talk: talk),
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
            src: talk.thumbnailUrl!,
            alt: '${talk.title}, ${talk.speaker.name}'
                '${talk.speaker.company != null ? ', ${talk.speaker.company}' : ''}',
            classes: 'talk-thumbnail',
          ),
        ]),
      ],
      href: talk.youtubeUrl!,
      attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
    );
  }
}
