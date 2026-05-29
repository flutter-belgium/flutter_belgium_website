import 'package:flutter_belgium_website/components/talks_section.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const talk = Talk(youtubeUrl: 'https://youtube.com/watch?v=abc');

  testComponents('TalksSection renders one card per talk', (tester) async {
    tester.pumpComponent(TalksSection(talks: [talk, talk]));
    expect(find.tag('img'), findsNComponents(2));
  });

  testComponents('TalksSection wraps each card in a YouTube link',
      (tester) async {
    tester.pumpComponent(TalksSection(talks: [talk]));
    expect(find.tag('a'), findsOneComponent);
    expect(find.tag('img'), findsOneComponent);
  });
}
