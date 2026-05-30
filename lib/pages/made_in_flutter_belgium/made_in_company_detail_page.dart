import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_card.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company.dart';
import 'package:flutter_belgium_website/util/made_in_utils.dart';

class MadeInCompanyDetailPage extends StatelessComponent {
  const MadeInCompanyDetailPage({
    required this.company,
    required this.communityLinks,
    super.key,
  });

  final MadeInCompany company;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'made-in-detail', [
        div(classes: 'made-in-detail-inner container', [
          div(classes: 'made-in-detail-header', [
            img(
              src: '/${company.localLogoPath}',
              alt: company.name,
              classes: 'made-in-detail-logo',
            ),
            div(classes: 'made-in-detail-meta', [
              if (!company.useLogoInsteadOfTextTitle)
                h1(classes: 'made-in-detail-title', [
                  Component.text(company.name),
                  if (company.isAgency)
                    span(classes: 'badge', [const Component.text('Agency')]),
                ]),
              if (company.useLogoInsteadOfTextTitle && company.isAgency)
                span(classes: 'badge', [const Component.text('Agency')]),
            ]),
          ]),
          if (company.description != null)
            p(
                classes: 'made-in-detail-description',
                [Component.text(company.description!)]),
          if (company.links != null)
            div(classes: 'made-in-detail-links', [
              a(
                [const Component.text('Website')],
                href: company.links!.website,
                classes: 'made-in-detail-link',
                attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
              ),
              if (company.links!.jobWebsite != null)
                a(
                  [const Component.text('Jobs')],
                  href: company.links!.jobWebsite!,
                  classes: 'made-in-detail-link',
                  attributes: {
                    'target': '_blank',
                    'rel': 'noopener noreferrer'
                  },
                ),
            ]),
          if (company.projects.isNotEmpty) ...[
            p(
                classes: 'made-in-detail-section-title',
                [const Component.text('Projects')]),
            div(classes: 'made-in-ref-grid', [
              for (final proj in company.projects)
                MadeInCard(
                  name: proj.name,
                  localImagePath: proj.localIconPath,
                  href: '/made-in-flutter-belgium/apps/${toSlug(proj.name)}',
                ),
            ]),
          ],
          if (company.involvedProjects.isNotEmpty) ...[
            p(
                classes: 'made-in-detail-section-title',
                [const Component.text('Involved in')]),
            div(classes: 'made-in-ref-grid', [
              for (final proj in company.involvedProjects)
                MadeInCard(
                  name: proj.name,
                  localImagePath: proj.localIconPath,
                  href: '/made-in-flutter-belgium/apps/${toSlug(proj.name)}',
                ),
            ]),
          ],
          if (company.developers.isNotEmpty) ...[
            p(
                classes: 'made-in-detail-section-title',
                [const Component.text('Developers')]),
            div(classes: 'made-in-ref-grid', [
              for (final dev in company.developers)
                MadeInCard(
                  name: dev.githubUserName,
                  localImagePath: dev.localAvatarPath,
                  href:
                      '/made-in-flutter-belgium/developers/${toSlug(dev.githubUserName)}',
                ),
            ]),
          ],
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
