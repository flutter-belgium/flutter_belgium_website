import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class SponsorSection extends StatelessComponent {
  const SponsorSection(
      {required this.sponsors, required this.contactUrl, super.key});

  final List<Sponsor> sponsors;
  final String contactUrl;

  @override
  Component build(BuildContext context) {
    return section(classes: 'sponsors', [
      div(classes: 'sponsors-inner container', [
        const p(classes: 'section-label', [Component.text('Sponsors')]),
        const h2(
            classes: 'section-title', [Component.text('Made possible by')]),
        const p(classes: 'sponsors-sub section-body', [
          Component.text(
              'These companies invested in a professional livestream setup so every meetup is recorded and available to rewatch, even for those who could not attend in person.'),
        ]),
        div(classes: 'sponsors-grid', [
          for (final sponsor in sponsors) _SponsorCard(sponsor: sponsor),
          _BecomeSponsorCard(contactUrl: contactUrl),
        ]),
      ]),
    ]);
  }
}

class _BecomeSponsorCard extends StatelessComponent {
  const _BecomeSponsorCard({required this.contactUrl});
  final String contactUrl;

  @override
  Component build(BuildContext context) {
    return a(
      [
        div(classes: 'become-sponsor-icon', [Component.text('+')]),
        span(
            classes: 'become-sponsor-label',
            [Component.text('Become a sponsor')]),
      ],
      href: '/become-a-sponsor',
      classes: 'sponsor-card sponsor-card-cta',
    );
  }
}

class _SponsorCard extends StatelessComponent {
  const _SponsorCard({required this.sponsor});
  final Sponsor sponsor;

  @override
  Component build(BuildContext context) {
    return a(
      [
        img(src: sponsor.logoUrl, alt: sponsor.name, classes: 'sponsor-logo'),
      ],
      href: sponsor.websiteUrl,
      classes: 'sponsor-card',
      target: Target.blank,
      attributes: {'rel': 'noopener noreferrer'},
    );
  }
}
