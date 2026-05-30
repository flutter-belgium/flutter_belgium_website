import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

const _playStoreUrl =
    'https://play.google.com/store/apps/details?id=be.flutterbelgium.app';
const _appStoreUrl =
    'https://apps.apple.com/nl/app/flutter-belgium/id6479450596';

class AppPage extends StatelessComponent {
  const AppPage({required this.communityLinks, super.key});

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
            const Component.text(
                'Get the Flutter Belgium app to join raffles at meetups and stay up to date with the community. Redirecting you to the right store…'),
          ]),
          div(classes: 'hero-actions', [
            a(
              [const Component.text('App Store')],
              href: _appStoreUrl,
              classes: 'btn btn-primary',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            ),
            a(
              [const Component.text('Play Store')],
              href: _playStoreUrl,
              classes: 'btn btn-secondary',
              attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
            ),
          ]),
        ]),
      ]),
      Footer(communityLinks: communityLinks),
      script(
        content: """
          var ua = navigator.userAgent || window.opera;
          if (/android/i.test(ua)) {
            window.location.replace('$_playStoreUrl');
          } else {
            window.location.replace('$_appStoreUrl');
          }
        """,
      ),
    ]);
  }
}
