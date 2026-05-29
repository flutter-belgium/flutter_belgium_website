import 'package:flutter_belgium_website/components/sponsor_section.dart';
import 'package:flutter_belgium_website/data/models/sponsor.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const sponsors = [
    Sponsor(
        name: 'impaktfull',
        logoUrl: '/assets/company/impaktfull.svg',
        websiteUrl: 'https://impaktfull.com'),
    Sponsor(
        name: 'diskwriter',
        logoUrl: '/assets/company/diskwriter.svg',
        websiteUrl: 'https://diskwriter.be'),
  ];

  testComponents(
      'SponsorSection renders label, title, and one card per sponsor',
      (tester) async {
    tester.pumpComponent(const SponsorSection(
        sponsors: sponsors,
        contactUrl: 'https://www.meetup.com/flutter-belgium/'));
    expect(find.tag('section'), findsOneComponent);
    expect(find.text('Sponsors'), findsOneComponent);
    expect(find.text('Made possible by'), findsOneComponent);
    expect(find.tag('img'), findsNComponents(2));
    expect(find.text('Become a sponsor'), findsOneComponent);
  });
}
