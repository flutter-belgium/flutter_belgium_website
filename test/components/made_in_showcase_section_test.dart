import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_showcase_section.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app_links.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  final apps = [
    MadeInApp(
      name: 'App One',
      localIconPath: 'assets/made_in/projects/App One/app_icon.webp',
      description: 'First app',
      releaseDate: DateTime(2025, 1, 1),
      isSunsetted: false,
      links: const MadeInAppLinks(),
      screenshotPaths: const [],
      developers: const [],
      involvedCompanies: const [],
    ),
    MadeInApp(
      name: 'App Two',
      localIconPath: 'assets/made_in/projects/App Two/app_icon.webp',
      description: 'Second app',
      releaseDate: DateTime(2025, 3, 1),
      isSunsetted: false,
      links: const MadeInAppLinks(),
      screenshotPaths: const [],
      developers: const [],
      involvedCompanies: const [],
    ),
  ];

  testComponents('MadeInShowcaseSection renders section label and CTA link',
      (tester) async {
    tester.pumpComponent(MadeInShowcaseSection(latestApps: apps));
    expect(find.tag('section'), findsOneComponent);
    expect(find.text('Explore what Belgians built with Flutter'),
        findsOneComponent);
  });

  testComponents('MadeInShowcaseSection renders a card per app',
      (tester) async {
    tester.pumpComponent(MadeInShowcaseSection(latestApps: apps));
    expect(find.text('App One'), findsOneComponent);
    expect(find.text('App Two'), findsOneComponent);
  });
}
