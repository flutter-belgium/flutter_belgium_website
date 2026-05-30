import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_card.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class MadeInDeveloperDetailPage extends StatelessComponent {
  const MadeInDeveloperDetailPage({
    required this.developer,
    required this.communityLinks,
    super.key,
  });

  final MadeInDeveloper developer;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    final displayName = developer.name ?? developer.githubUserName;

    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'made-in-detail', [
        div(classes: 'made-in-detail-inner container', [
          div(classes: 'made-in-detail-header', [
            img(
              src: '/${developer.localAvatarPath}',
              alt: displayName,
              classes: 'made-in-detail-avatar',
            ),
            div(classes: 'made-in-detail-meta', [
              h1(
                  classes: 'made-in-detail-title',
                  [Component.text(displayName)]),
              a(
                [Component.text('@${developer.githubUserName}')],
                href: 'https://github.com/${developer.githubUserName}',
                classes: 'made-in-detail-subtitle',
                attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
              ),
            ]),
          ]),
          if (developer.description != null)
            p(
                classes: 'made-in-detail-description',
                [Component.text(developer.description!)]),
          if (developer.links != null)
            div(classes: 'made-in-detail-links', [
              if (developer.links!.linkedin != null)
                a(
                  [const Component.text('LinkedIn')],
                  href: developer.links!.linkedin!,
                  classes: 'made-in-detail-link',
                  attributes: {
                    'target': '_blank',
                    'rel': 'noopener noreferrer'
                  },
                ),
              if (developer.links!.personalWebsite != null)
                a(
                  [const Component.text('Website')],
                  href: developer.links!.personalWebsite!,
                  classes: 'made-in-detail-link',
                  attributes: {
                    'target': '_blank',
                    'rel': 'noopener noreferrer'
                  },
                ),
              if (developer.links!.freelanceWebsite != null)
                a(
                  [const Component.text('Freelance')],
                  href: developer.links!.freelanceWebsite!,
                  classes: 'made-in-detail-link',
                  attributes: {
                    'target': '_blank',
                    'rel': 'noopener noreferrer'
                  },
                ),
            ]),
          if (developer.projects.isNotEmpty) ...[
            p(
                classes: 'made-in-detail-section-title',
                [const Component.text('Projects')]),
            div(classes: 'made-in-ref-grid', [
              for (final proj in developer.projects)
                MadeInCard(
                  name: proj.name,
                  localImagePath: proj.localIconPath,
                  href: '/made-in-flutter-belgium/apps/${toSlug(proj.name)}',
                ),
            ]),
          ],
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
