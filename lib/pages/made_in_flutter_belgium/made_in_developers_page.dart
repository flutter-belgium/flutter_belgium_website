import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_add_card.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_card.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_page_shell.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class MadeInDevelopersPage extends StatelessComponent {
  const MadeInDevelopersPage({
    required this.developers,
    required this.communityLinks,
    super.key,
  });

  final List<MadeInDeveloper> developers;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      MadeInPageShell(
        activeTab: MadeInTab.developers,
        child: [
          div(classes: 'made-in-grid', [
            for (final dev in developers)
              MadeInCard(
                name: dev.name ?? dev.githubUserName,
                localImagePath: dev.localAvatarPath,
                href:
                    '/made-in-flutter-belgium/developers/${toSlug(dev.githubUserName)}',
              ),
            const MadeInAddCard(
              href:
                  'https://github.com/flutter-belgium/made_in_flutter_belgium_data/wiki/Developers',
              label: 'Add yourself',
            ),
          ]),
        ],
      ),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
