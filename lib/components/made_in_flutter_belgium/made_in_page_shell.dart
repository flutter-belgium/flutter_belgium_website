import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

enum MadeInTab { apps, companies, developers }

class MadeInPageShell extends StatelessComponent {
  const MadeInPageShell({
    required this.activeTab,
    required this.child,
    super.key,
  });

  final MadeInTab activeTab;
  final List<Component> child;

  @override
  Component build(BuildContext context) {
    return section(classes: 'made-in-page', [
      div(classes: 'made-in-page-inner', [
        h1(
            classes: 'made-in-hero-tagline',
            [const Component.text('Made in (Flutter) Belgium')]),
        p(classes: 'made-in-hero-sub', [
          const Component.text(
              'Apps, companies and developers from Belgium building with Flutter.'),
        ]),
        div(classes: 'hero-actions made-in-tabs', [
          a(
            [const Component.text('apps')],
            href: '/made-in-flutter-belgium/apps',
            classes: activeTab == MadeInTab.apps
                ? 'btn btn-primary'
                : 'btn btn-secondary',
          ),
          a(
            [const Component.text('companies')],
            href: '/made-in-flutter-belgium/companies',
            classes: activeTab == MadeInTab.companies
                ? 'btn btn-primary'
                : 'btn btn-secondary',
          ),
          a(
            [const Component.text('developers')],
            href: '/made-in-flutter-belgium/developers',
            classes: activeTab == MadeInTab.developers
                ? 'btn btn-primary'
                : 'btn btn-secondary',
          ),
        ]),
        div(classes: 'made-in-content', child),
      ]),
    ]);
  }
}
