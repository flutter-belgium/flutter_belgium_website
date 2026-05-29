import 'package:flutter_belgium_website/components/past_meetups_section.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  final meetups = [
    Meetup(
        id: '1',
        title: 'Flutter Belgium #1',
        date: DateTime(2023, 11, 16),
        hostCompany: 'iO',
        location: 'Ghent',
        thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif'),
    Meetup(
        id: '2',
        title: 'Flutter Belgium #2',
        date: DateTime(2024, 2, 22),
        hostCompany: 'Zimmo',
        location: 'Antwerp',
        thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif'),
  ];

  testComponents('PastMeetupsSection renders a card per meetup',
      (tester) async {
    tester.pumpComponent(PastMeetupsSection(meetups: meetups, meetupGroupUrl: 'https://www.meetup.com/flutter-belgium/'));
    expect(find.tag('article'), findsNComponents(2));
    expect(find.tag('img'), findsNComponents(2));
  });
}
