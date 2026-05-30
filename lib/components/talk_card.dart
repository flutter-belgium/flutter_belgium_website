import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/talk.dart';

class TalkCard extends StatelessComponent {
  const TalkCard({required this.talk, super.key});

  final Talk talk;

  @override
  Component build(BuildContext context) {
    return a(
      [
        article(classes: 'talk-card', [
          img(
            src: talk.thumbnailUrl!,
            alt: talk.title,
            classes: 'talk-thumbnail',
          ),
        ]),
      ],
      href: talk.youtubeUrl!,
      classes: 'talk-link',
      target: Target.blank,
      attributes: {'rel': 'noopener noreferrer'},
    );
  }
}
