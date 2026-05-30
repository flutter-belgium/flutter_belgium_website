import 'package:flutter_belgium_data/flutter_belgium_data.dart';
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_showcase_section.dart';
import 'package:jaspr/jaspr.dart';
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

  testComponents('MadeInShowcaseSection renders a scrolling strip',
      (tester) async {
    tester.pumpComponent(MadeInShowcaseSection(latestApps: apps));
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('app-showcase-strip') ?? false),
      ),
      findsOneComponent,
    );
  });

  testComponents(
      'MadeInShowcaseSection renders a card per app (doubled for scroll loop)',
      (tester) async {
    tester.pumpComponent(MadeInShowcaseSection(latestApps: apps));
    // Each app is duplicated for seamless infinite scroll.
    expect(find.text('App One'), findsNComponents(2));
    expect(find.text('App Two'), findsNComponents(2));
  });
}
