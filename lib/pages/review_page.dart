import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';

const _reviewUrl =
    'https://docs.google.com/forms/d/e/1FAIpQLSfcmBmF7d4gwQ4km6VfokeMdyWjyp2uVkcx0e379ubfZ2WEpg/viewform?usp=dialog';

class ReviewPage extends StatelessComponent {
  const ReviewPage({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'legal', [
        div(classes: 'legal-inner container', [
          h1(
              classes: 'legal-title',
              [const Component.text('Review Flutter Belgium')]),
          p(classes: 'legal-body', [
            const Component.text(
                'Redirecting you to the Flutter Belgium review form…'),
          ]),
        ]),
      ]),
      Footer(communityLinks: communityLinks),
      script(content: "window.location.replace('$_reviewUrl');"),
    ]);
  }
}
