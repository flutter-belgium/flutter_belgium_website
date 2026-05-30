import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_card.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  testComponents('MadeInCard renders image and name, links to href',
      (tester) async {
    tester.pumpComponent(const MadeInCard(
      name: 'Bevoy',
      localImagePath: 'assets/made_in/projects/Bevoy/app_icon.webp',
      href: '/made-in-flutter-belgium/apps/bevoy',
    ));
    expect(find.tag('a'), findsOneComponent);
    expect(find.tag('img'), findsOneComponent);
    expect(find.text('Bevoy'), findsOneComponent);
  });
}
