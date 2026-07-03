import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';
import 'package:flutter_belgium_website/data/repositories/mock_flutter_belgium_repository.dart';
import 'package:test/test.dart';

void main() {
  late MockFlutterBelgiumRepository repo;
  setUp(() => repo = MockFlutterBelgiumRepository());

  test('getNextMeetup returns a Meetup with non-empty fields', () async {
    final meetup = await repo.getNextMeetup();
    if (meetup != null) {
      expect(meetup.id, isNotEmpty);
      expect(meetup.hostCompany, isNotEmpty);
    }
  });

  test('getPastMeetups returns a non-empty list of Meetup', () async {
    final meetups = await repo.getPastMeetups();
    expect(meetups, isA<List<Meetup>>());
    expect(meetups, isNotEmpty);
  });

  test('getAllTalks returns talks with non-empty id and title', () async {
    final talks = await repo.getAllTalks();
    expect(talks, isA<List<Talk>>());
    expect(talks, isNotEmpty);
    for (final talk in talks) {
      expect(talk.id, isNotEmpty);
      expect(talk.title, isNotEmpty);
    }
  });

  test('getCommunityLinks returns valid URLs for all links', () async {
    final links = await repo.getCommunityLinks();
    expect(links, isA<CommunityLinks>());
    expect(links.slackInviteUrl, startsWith('https://'));
    expect(links.youtubeChannelUrl, startsWith('https://'));
    expect(links.meetupUrl, startsWith('https://'));
    expect(links.linkedinUrl, startsWith('https://'));
    expect(links.githubUrl, startsWith('https://'));
    expect(links.madeInUrl, isNotEmpty);
  });

  test('getHostingCompanies returns companies with non-empty fields', () async {
    final companies = await repo.getHostingCompanies();
    expect(companies, isA<List<Company>>());
    expect(companies, isNotEmpty);
    for (final c in companies) {
      expect(c.name, isNotEmpty);
      expect(c.logoUrl, isNotEmpty);
      expect(c.websiteUrl, startsWith('https://'));
    }
  });

  test('getTestimonials returns 7 testimonials with non-empty fields',
      () async {
    final testimonials = await repo.getTestimonials();
    expect(testimonials, isA<List<Testimonial>>());
    expect(testimonials, hasLength(7));
    for (final t in testimonials) {
      expect(t.text, isNotEmpty);
      expect(t.author.name, isNotEmpty);
      expect(t.author.activeCompany, isNotNull);
    }
  });

  test('getTeamMembers returns 3 members with non-empty fields', () async {
    final members = await repo.getTeamMembers();
    expect(members, hasLength(3));
    for (final m in members) {
      expect(m.name, isNotEmpty);
      expect(m.role, isNotEmpty);
      expect(m.avatarUrl, isNotEmpty);
    }
  });

  test('getSponsors returns 2 sponsors with non-empty fields', () async {
    final sponsors = await repo.getSponsors();
    expect(sponsors, hasLength(2));
    for (final s in sponsors) {
      expect(s.name, isNotEmpty);
      expect(s.websiteUrl, startsWith('https://'));
    }
  });

  test('getUpcomingMeetups returns meetups sorted ascending by date', () async {
    final meetups = await repo.getUpcomingMeetups();
    expect(meetups, isA<List<Meetup>>());
    for (var i = 0; i < meetups.length - 1; i++) {
      expect(meetups[i].date.isBefore(meetups[i + 1].date), isTrue);
    }
  });

  test('getPersons returns persons with non-empty id and name', () async {
    final persons = await repo.getPersons();
    expect(persons, isA<List<Person>>());
    expect(persons, isNotEmpty);
    for (final p in persons) {
      expect(p.id, isNotEmpty);
      expect(p.name, isNotEmpty);
    }
  });

  test('getMeetupBySlug returns the correct meetup', () async {
    final meetup = await repo.getMeetupBySlug('flutter-belgium-26');
    expect(meetup, isNotNull);
    expect(meetup!.id, 'meetup-3');
  });

  test('getMeetupBySlug returns null for unknown slug', () async {
    final meetup = await repo.getMeetupBySlug('does-not-exist');
    expect(meetup, isNull);
  });

  test('getPastMeetups returns meetups with embedded talks', () async {
    final meetups = await repo.getPastMeetups();
    final meetupsWithTalks = meetups.where((m) => m.talks.isNotEmpty).toList();
    expect(meetupsWithTalks, isNotEmpty);
    for (final meetup in meetupsWithTalks) {
      for (final talk in meetup.talks) {
        expect(talk.id, isNotEmpty);
        expect(talk.title, isNotEmpty);
      }
    }
  });
}
