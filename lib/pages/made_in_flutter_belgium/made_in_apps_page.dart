import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_add_card.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_card.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_page_shell.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class MadeInAppsPage extends StatelessComponent {
  const MadeInAppsPage({
    required this.apps,
    required this.communityLinks,
    super.key,
  });

  final List<MadeInApp> apps;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      MadeInPageShell(
        activeTab: MadeInTab.apps,
        child: [
          div(classes: 'made-in-grid', [
            for (final app in apps)
              MadeInCard(
                name: app.name,
                localImagePath: app.localIconPath,
                href: '/made-in-flutter-belgium/apps/${toSlug(app.name)}',
              ),
            const MadeInAddCard(
              href:
                  'https://github.com/flutter-belgium/made_in_flutter_belgium_data/wiki/Projects',
              label: 'Add your app',
            ),
          ]),
        ],
      ),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
