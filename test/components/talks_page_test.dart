import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/pages/talks/talks_page.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

import '../test_data.dart';

void main() {
  const links = testCommunityLinks;

  final talkWithVideo = Talk(
    id: 't1',
    title: 'Test Talk',
    date: DateTime(2026, 2, 1),
    youtubeUrl: 'https://youtube.com/watch?v=abc',
    speakers: const [],
  );
  final talkNoVideo = Talk(
    id: 't2',
    title: 'No Video',
    date: DateTime(2026, 1, 1),
    speakers: const [],
  );

  testComponents('TalksPage renders one card per talk with video',
      (tester) async {
    tester.pumpComponent(TalksPage(
        talks: [talkWithVideo, talkWithVideo], communityLinks: links));
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('talk-thumbnail') ?? false),
        description: 'talk thumbnail image',
      ),
      findsNComponents(2),
    );
  });

  testComponents('TalksPage skips talks without a valid thumbnail URL',
      (tester) async {
    tester.pumpComponent(
        TalksPage(talks: [talkWithVideo, talkNoVideo], communityLinks: links));
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('talk-thumbnail') ?? false),
        description: 'talk thumbnail image',
      ),
      findsOneComponent,
    );
  });

  testComponents('TalksPage each video card links to YouTube', (tester) async {
    tester.pumpComponent(
        TalksPage(talks: [talkWithVideo], communityLinks: links));
    expect(
      find.byComponentPredicate(
        (c) => c is DomComponent && (c.classes?.contains('talk-link') ?? false),
        description: 'talk link',
      ),
      findsOneComponent,
    );
  });
}
