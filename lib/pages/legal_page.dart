import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';

class LegalPage extends StatelessComponent {
  const LegalPage({
    required this.communityLinks,
    required this.title,
    required this.sections,
    super.key,
  });

  final CommunityLinks communityLinks;
  final String title;
  final List<LegalSection> sections;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'legal', [
        div(classes: 'legal-inner container', [
          h1(classes: 'legal-title', [Component.text(title)]),
          for (final section in sections) ...[
            h2(
                classes: 'legal-section-title',
                [Component.text(section.heading)]),
            for (final paragraph in section.paragraphs)
              p(classes: 'legal-body', [Component.text(paragraph)]),
          ],
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }
}

class LegalSection {
  const LegalSection({required this.heading, required this.paragraphs});
  final String heading;
  final List<String> paragraphs;
}
