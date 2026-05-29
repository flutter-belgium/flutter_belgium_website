import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_add_card.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_card.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_page_shell.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company.dart';
import 'package:flutter_belgium_website/util/made_in_utils.dart';

class MadeInCompaniesPage extends StatelessComponent {
  const MadeInCompaniesPage({
    required this.companies,
    required this.communityLinks,
    super.key,
  });

  final List<MadeInCompany> companies;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      MadeInPageShell(
        activeTab: MadeInTab.companies,
        child: [
          div(classes: 'made-in-grid-logos', [
            for (final company in companies)
              MadeInCard(
                name: company.name,
                localImagePath: company.localLogoPath,
                href:
                    '/made-in-flutter-belgium/companies/${toSlug(company.name)}',
                isLogo: true,
              ),
            const MadeInAddCard(
              href:
                  'https://github.com/flutter-belgium/made_in_flutter_belgium_data/wiki/Companies',
              label: 'Add your company',
              isLogo: true,
            ),
          ]),
        ],
      ),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
