import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app.dart';
import 'package:flutter_belgium_website/util/made_in_utils.dart';

class MadeInShowcaseSection extends StatelessComponent {
  const MadeInShowcaseSection({required this.latestApps, super.key});

  final List<MadeInApp> latestApps;

  @override
  Component build(BuildContext context) {
    // Duplicate for seamless infinite scroll loop
    final doubled = [...latestApps, ...latestApps];
    return div(classes: 'app-showcase-strip', [
      div(classes: 'app-showcase-track', [
        for (final app in doubled)
          a(
            [
              img(
                src: '/${app.localIconPath}',
                alt: app.name,
                classes: 'app-showcase-icon',
              ),
              span(classes: 'app-showcase-label', [Component.text(app.name)]),
            ],
            href: '/made-in-flutter-belgium/apps/${toSlug(app.name)}',
            classes: 'app-showcase-item',
          ),
      ]),
    ]);
  }
}
