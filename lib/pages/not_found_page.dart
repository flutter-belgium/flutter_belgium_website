import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';

class NotFoundPage extends StatelessComponent {
  const NotFoundPage({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'legal', [
        div(classes: 'legal-inner container', [
          h1(classes: 'legal-title', [const Component.text('Page not found')]),
          p(classes: 'legal-body', [
            const Component.text(
                "The page you're looking for doesn't exist or may have moved."),
          ]),
          div(attributes: {
            'style': 'margin-top: 2rem'
          }, [
            a(
              [const Component.text('Go home')],
              href: '/',
              classes: 'btn btn-primary',
            ),
          ]),
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
