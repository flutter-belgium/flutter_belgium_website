import 'package:flutter_belgium_website/components/talks_section.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  final talkWithVideo = Talk(
    id: 't1',
    title: 'Test Talk',
    date: DateTime(2026, 1, 1),
    youtubeUrl: 'https://youtube.com/watch?v=abc',
    speakers: const [],
  );
  final talkWithoutVideo = Talk(
    id: 't2',
    title: 'No Video',
    date: DateTime(2026, 1, 1),
    speakers: const [],
  );

  testComponents('TalksSection renders one card per talk with video',
      (tester) async {
    tester.pumpComponent(TalksSection(talks: [talkWithVideo, talkWithVideo]));
    expect(find.tag('img'), findsNComponents(2));
  });

  testComponents('TalksSection skips talks without a YouTube URL',
      (tester) async {
    tester
        .pumpComponent(TalksSection(talks: [talkWithVideo, talkWithoutVideo]));
    expect(find.tag('img'), findsOneComponent);
  });

  testComponents('TalksSection renders View all talks button', (tester) async {
    tester.pumpComponent(TalksSection(talks: [talkWithVideo]));
    expect(find.text('View all talks'), findsOneComponent);
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('btn-secondary') ?? false),
      ),
      findsOneComponent,
    );
  });

  testComponents(
      'TalksSection renders View all talks button even when no talks have video',
      (tester) async {
    tester.pumpComponent(TalksSection(talks: [talkWithoutVideo]));
    expect(find.tag('img'), findsNothing);
    expect(find.text('View all talks'), findsOneComponent);
  });
}
