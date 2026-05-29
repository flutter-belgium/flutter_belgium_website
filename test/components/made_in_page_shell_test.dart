import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_page_shell.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  testComponents('MadeInPageShell renders hero title and all three tabs',
      (tester) async {
    tester.pumpComponent(const MadeInPageShell(
      activeTab: MadeInTab.apps,
      child: [],
    ));
    expect(find.text('Made in (Flutter) Belgium'), findsOneComponent);
    expect(find.text('apps'), findsOneComponent);
    expect(find.text('companies'), findsOneComponent);
    expect(find.text('developers'), findsOneComponent);
  });

  testComponents('MadeInPageShell marks the active tab with btn-primary',
      (tester) async {
    tester.pumpComponent(const MadeInPageShell(
      activeTab: MadeInTab.companies,
      child: [],
    ));
    final activeBtn = find.byComponentPredicate(
      (c) =>
          c is DomComponent &&
          (c.classes?.contains('btn-primary') ?? false) &&
          (c.classes?.contains('btn') ?? false),
      description: 'active tab button with btn-primary class',
    );
    expect(activeBtn, findsOneComponent);
  });
}
