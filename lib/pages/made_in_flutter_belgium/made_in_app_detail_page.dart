import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_card.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class MadeInAppDetailPage extends StatelessComponent {
  const MadeInAppDetailPage({
    required this.app,
    required this.communityLinks,
    super.key,
  });

  final MadeInApp app;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'made-in-detail', [
        div(classes: 'made-in-detail-inner container', [
          div(classes: 'made-in-detail-header', [
            img(
              src: '/${app.localIconPath}',
              alt: app.name,
              classes: 'made-in-detail-icon',
            ),
            div(classes: 'made-in-detail-meta', [
              h1(classes: 'made-in-detail-title', [Component.text(app.name)]),
              p(
                  classes: 'made-in-detail-subtitle',
                  [Component.text(_formatDate(app.releaseDate))]),
            ]),
          ]),
          if (app.isSunsetted)
            div(classes: 'made-in-detail-sunset', [
              Component.text(
                  'This app has been sunset.${app.sunsetReason != null ? ' ${app.sunsetReason}' : ''}'),
            ]),
          p(
              classes: 'made-in-detail-description',
              [Component.text(app.description)]),
          _buildLinks(),
          if (app.screenshotPaths.isNotEmpty) ...[
            p(
                classes: 'made-in-detail-section-title',
                [const Component.text('Screenshots')]),
            div(classes: 'made-in-screenshots', [
              for (final path in app.screenshotPaths)
                img(
                    src: '/$path',
                    alt: 'Screenshot',
                    classes: 'made-in-screenshot'),
            ]),
          ],
          if (app.publisherCompany != null) ...[
            p(
                classes: 'made-in-detail-section-title',
                [const Component.text('Publisher')]),
            div(classes: 'made-in-grid-logos', [
              MadeInCard(
                name: app.publisherCompany!.name,
                localImagePath: app.publisherCompany!.localLogoPath,
                href: '/made-in-flutter-belgium/companies/${toSlug(app.publisherCompany!.name)}',
                isLogo: true,
              ),
            ]),
          ],
          if (app.developers.isNotEmpty) ...[
            p(
                classes: 'made-in-detail-section-title',
                [const Component.text('Dev team')]),
            div(classes: 'made-in-ref-grid', [
              for (final d in app.developers)
                MadeInCard(
                  name: d.githubUserName,
                  localImagePath: d.localAvatarPath,
                  href:
                      '/made-in-flutter-belgium/developers/${toSlug(d.githubUserName)}',
                ),
            ]),
          ],
          if (app.involvedCompanies.isNotEmpty) ...[
            p(
                classes: 'made-in-detail-section-title',
                [const Component.text('Involved companies')]),
            div(classes: 'made-in-grid-logos-sm', [
              for (final c in app.involvedCompanies)
                MadeInCard(
                  name: c.name,
                  localImagePath: c.localLogoPath,
                  href: '/made-in-flutter-belgium/companies/${toSlug(c.name)}',
                  isLogo: true,
                ),
            ]),
          ],
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }

  Component _buildLinks() {
    final links = <Component>[];
    final l = app.links;
    if (l.appstore != null) {
      links.add(_link('App Store', l.appstore!));
    }
    if (l.playstore != null) {
      links.add(_link('Play Store', l.playstore!));
    }
    if (l.webApp != null) {
      links.add(_link('Web App', l.webApp!));
    }
    if (l.marketingWebsite != null) {
      links.add(_link('Website', l.marketingWebsite!));
    }
    if (l.openSourceCode != null) {
      links.add(_link('Open Source', l.openSourceCode!));
    }
    if (l.youTube != null) {
      links.add(_link('YouTube', l.youTube!));
    }
    if (l.demoYouTubeVideo != null) {
      links.add(_link('Demo Video', l.demoYouTubeVideo!));
    }
    if (links.isEmpty) {
      return Component.fragment([]);
    }
    return div(classes: 'made-in-detail-links', links);
  }

  Component _link(String label, String url) => a(
        [Component.text(label)],
        href: url,
        classes: 'made-in-detail-link',
        attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
      );

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
