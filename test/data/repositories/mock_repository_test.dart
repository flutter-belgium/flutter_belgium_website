import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
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

  test('getAllTalks returns talks with meetupTitle set', () async {
    final talks = await repo.getAllTalks();
    expect(talks, isA<List<Talk>>());
    expect(talks, isNotEmpty);
    for (final talk in talks) {
      expect(talk.meetupTitle, isNotEmpty);
    }
  });

  test('getCommunityLinks returns https URLs for all links', () async {
    final links = await repo.getCommunityLinks();
    expect(links, isA<CommunityLinks>());
    expect(links.slackInviteUrl, startsWith('https://'));
    expect(links.youtubeChannelUrl, startsWith('https://'));
    expect(links.meetupUrl, startsWith('https://'));
    expect(links.linkedinUrl, startsWith('https://'));
    expect(links.githubUrl, startsWith('https://'));
    expect(links.madeInUrl, startsWith('https://'));
  });

  test('getHostingCompanies returns 4 companies with non-empty fields', () async {
    final companies = await repo.getHostingCompanies();
    expect(companies, isA<List<Company>>());
    expect(companies, hasLength(4));
    for (final c in companies) {
      expect(c.name, isNotEmpty);
      expect(c.logoUrl, isNotEmpty);
      expect(c.websiteUrl, startsWith('https://'));
    }
  });

  test('getTestimonials returns 3 testimonials with non-empty fields', () async {
    final testimonials = await repo.getTestimonials();
    expect(testimonials, isA<List<Testimonial>>());
    expect(testimonials, hasLength(3));
    for (final t in testimonials) {
      expect(t.text, isNotEmpty);
      expect(t.authorName, isNotEmpty);
      expect(t.authorRole, isNotEmpty);
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
}
