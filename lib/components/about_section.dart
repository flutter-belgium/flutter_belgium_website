import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_showcase_section.dart';

class AboutSection extends StatelessComponent {
  const AboutSection({
    required this.latestApps,
    required this.madeInUrl,
    super.key,
  });

  final List<MadeInApp> latestApps;
  final String madeInUrl;

  @override
  Component build(BuildContext context) {
    return section(id: 'about', classes: 'about', [
      div(classes: 'about-inner', [
        const p(classes: 'section-label', [Component.text('About us')]),
        const h2(
            classes: 'section-title',
            [Component.text('Flutter developers, made in Belgium')]),
        const p(classes: 'section-body', [
          Component.text(
            'Flutter Belgium is a community of Flutter developers across Belgium. '
            'Every two to three months we host a meetup at a Belgian company that '
            'uses Flutter in production. Talks are recorded and published on YouTube, '
            'and our Slack is where the conversation keeps going between events.',
          ),
        ]),
        const p(classes: 'section-body about-made-in-text', [
          Component.text(
            'We also celebrate what the community builds. '
            'Made in Flutter Belgium is our curated collection of apps, companies and developers '
            'from Belgium shipping real products with Flutter.',
          ),
        ]),
        a(
          [const Component.text('View the collection')],
          href: madeInUrl,
          classes: 'btn btn-secondary about-apps-cta',
        ),
      ]),
      MadeInShowcaseSection(latestApps: latestApps),
    ]);
  }
}
