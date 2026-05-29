import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/models/company.dart';

class HostingCompaniesSection extends StatelessComponent {
  const HostingCompaniesSection({required this.companies, super.key});

  final List<Company> companies;

  @override
  Component build(BuildContext context) {
    // Each row uses all companies so both rows are always populated.
    final track1 = [for (var i = 0; i < 20; i++) ...companies];
    final track2 = [for (var i = 0; i < 20; i++) ...companies];

    return section(classes: 'hosting-companies', [
      div(classes: 'hosting-companies-header container', [
        p(classes: 'section-label', [Component.text('Hosted at')]),
        h2(
            classes: 'section-title',
            [Component.text('Flutter Belgium hosting companies')]),
      ]),
      div(classes: 'companies-carousel', [
        div(classes: 'companies-fade', [
          div(classes: 'companies-row', [
            div(classes: 'companies-track companies-track-left', [
              for (final company in track1) _logoItem(company),
            ]),
          ]),
          div(classes: 'companies-row', [
            div(classes: 'companies-track companies-track-right', [
              for (final company in track2) _logoItem(company),
            ]),
          ]),
        ]),
      ]),
    ]);
  }

  Component _logoItem(Company company) {
    return a(
      [
        img(
          src: company.logoUrl,
          alt: company.name,
          classes: 'company-logo-img',
        ),
      ],
      href: company.websiteUrl,
      classes: 'company-logo',
      attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
    );
  }
}
