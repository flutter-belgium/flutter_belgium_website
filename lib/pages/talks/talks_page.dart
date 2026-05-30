import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/components/talk_card.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class TalksPage extends StatelessComponent {
  const TalksPage({
    required this.talks,
    required this.communityLinks,
    super.key,
  });

  final List<Talk> talks;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    final withVideo = talks.where((t) => t.thumbnailUrl != null).toList();
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'talks', [
        div(classes: 'talks-inner container', [
          const p(classes: 'section-label', [Component.text('Talks')]),
          const h1(
              classes: 'section-title',
              [Component.text('Catch up on what you missed')]),
          div(classes: 'talks-grid', [
            for (final talk in withVideo) TalkCard(talk: talk),
          ]),
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
