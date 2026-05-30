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
    return section(classes: 'list-page', [
      div(classes: 'list-page-inner container', [
        h1(
            classes: 'list-page-tagline',
            [const Component.text('Made in (Flutter) Belgium')]),
        p(classes: 'list-page-sub', [
          const Component.text(
              'Apps, companies and developers from Belgium building with Flutter.'),
        ]),
        div(classes: 'hero-actions page-tabs', [
          a(
            [const Component.text('Apps')],
            href: '/made-in-flutter-belgium/apps',
            classes: activeTab == MadeInTab.apps
                ? 'btn btn-primary'
                : 'btn btn-secondary',
          ),
          a(
            [const Component.text('Companies')],
            href: '/made-in-flutter-belgium/companies',
            classes: activeTab == MadeInTab.companies
                ? 'btn btn-primary'
                : 'btn btn-secondary',
          ),
          a(
            [const Component.text('Developers')],
            href: '/made-in-flutter-belgium/developers',
            classes: activeTab == MadeInTab.developers
                ? 'btn btn-primary'
                : 'btn btn-secondary',
          ),
        ]),
        div(classes: 'list-page-content', child),
      ]),
    ]);
  }
}
