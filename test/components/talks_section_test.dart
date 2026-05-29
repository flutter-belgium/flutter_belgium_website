import 'package:flutter_belgium_website/components/talks_section.dart';
import 'package:flutter_belgium_website/data/models/speaker.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const thumbnail = '/assets/talk/flutter_belgium_talk.jpeg';

  final talks = [
    const Talk(
        id: 't1',
        title: 'Getting Started with Flutter',
        speaker: Speaker(name: 'Jan Peeters', company: 'iO'),
        meetupId: '1',
        meetupTitle: 'Flutter Belgium #1',
        youtubeUrl: 'https://youtube.com/watch?v=abc',
        thumbnailUrl: thumbnail),
    const Talk(
        id: 't2',
        title: 'State Management',
        speaker: Speaker(name: 'Lisa Maes'),
        meetupId: '2',
        meetupTitle: 'Flutter Belgium #2',
        thumbnailUrl: thumbnail),
  ];

  testComponents(
      'TalksSection shows only talks with both youtubeUrl and thumbnailUrl',
      (tester) async {
    tester.pumpComponent(TalksSection(talks: talks));
    // talks[0] has both — shown. talks[1] has no youtubeUrl — hidden.
    expect(find.tag('img'), findsOneComponent);
  });

  testComponents('TalksSection wraps qualifying card in a YouTube link',
      (tester) async {
    tester.pumpComponent(TalksSection(talks: [talks[0]]));
    expect(find.tag('a'), findsOneComponent);
    expect(find.tag('img'), findsOneComponent);
  });

  testComponents('TalksSection hides talk without youtubeUrl', (tester) async {
    tester.pumpComponent(TalksSection(talks: [talks[1]]));
    expect(find.tag('article'), findsNothing);
  });
}
