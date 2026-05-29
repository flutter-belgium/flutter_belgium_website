import 'package:flutter_belgium_website/components/hosting_companies_section.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const companies = [
    Company(
        name: 'iO',
        logoUrl: '/assets/logos/io.svg',
        websiteUrl: 'https://iodigital.com'),
    Company(
        name: 'Zimmo',
        logoUrl: '/assets/logos/zimmo.svg',
        websiteUrl: 'https://zimmo.be'),
    Company(
        name: 'Cegeka',
        logoUrl: '/assets/logos/cegeka.svg',
        websiteUrl: 'https://cegeka.com'),
    Company(
        name: 'Cronos',
        logoUrl: '/assets/logos/cronos.svg',
        websiteUrl: 'https://cronos.be'),
  ];

  testComponents(
      'HostingCompaniesSection renders section label, title, and two scroll tracks',
      (tester) async {
    tester.pumpComponent(const HostingCompaniesSection(companies: companies));
    expect(find.tag('section'), findsOneComponent);
    expect(find.text('Hosted at'), findsOneComponent);
    expect(find.text('Flutter Belgium hosting companies'), findsOneComponent);
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('companies-track-left') ?? false),
      ),
      findsOneComponent,
    );
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('companies-track-right') ?? false),
      ),
      findsOneComponent,
    );
  });
}
