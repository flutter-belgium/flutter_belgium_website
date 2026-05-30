import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class ScanPage extends StatelessComponent {
  const ScanPage({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'legal', [
        div(classes: 'legal-inner container', [
          h1(
              classes: 'legal-title',
              [const Component.text('Flutter Belgium app')]),
          p(classes: 'legal-body', [
            const Component.text('Redirecting you to the Flutter Belgium app…'),
          ]),
        ]),
      ]),
      Footer(communityLinks: communityLinks),
      script(content: "window.location.replace('/app');"),
    ]);
  }
}
