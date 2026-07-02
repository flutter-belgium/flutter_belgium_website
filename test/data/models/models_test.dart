import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';
import 'package:flutter_belgium_website/data/models/sponsor.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/models/team_member.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';
import 'package:test/test.dart';

import '../../test_data.dart';

void main() {
  group('Meetup', () {
    test('constructs with required fields, description defaults to null', () {
      final meetup = Meetup(
        id: '1',
        title: 'Flutter Belgium #1',
        date: DateTime(2024, 3, 14),
        hostCompany: 'iO',
        location: 'Ghent',
      );
      expect(meetup.id, '1');
      expect(meetup.description, isNull);
    });

    test('slug is derived from title', () {
      final meetup = Meetup(
        id: '1',
        title: 'Flutter Belgium #22',
        date: DateTime(2026, 2, 3),
        hostCompany: 'Acme',
        location: 'Ghent',
      );
      expect(meetup.slug, 'flutter-belgium-22');
    });

    test('talks defaults to empty list', () {
      final meetup = Meetup(
        id: '1',
        title: 'Flutter Belgium #1',
        date: DateTime(2024, 3, 14),
        hostCompany: 'iO',
        location: 'Ghent',
      );
      expect(meetup.talks, isEmpty);
    });

    test('talks contains provided talks', () {
      final talk = Talk(
        id: 't1',
        title: 'A talk',
        date: DateTime(2024, 3, 14),
        speakers: const [],
      );
      final meetup = Meetup(
        id: '1',
        title: 'Flutter Belgium #1',
        date: DateTime(2024, 3, 14),
        hostCompany: 'iO',
        location: 'Ghent',
        talks: [talk],
      );
      expect(meetup.talks, hasLength(1));
      expect(meetup.talks.first.id, 't1');
    });
  });

  group('Talk', () {
    final talk = Talk(
      id: 'talk-1',
      title: 'Building reactive UIs',
      date: DateTime(2026, 2, 3),
      youtubeUrl: 'https://www.youtube.com/watch?v=abc123',
      speakers: const [],
    );

    test('constructs with all fields', () {
      expect(talk.id, 'talk-1');
      expect(talk.title, 'Building reactive UIs');
    });

    test('thumbnailUrl derived from youtubeUrl when present', () {
      expect(talk.thumbnailUrl, contains('abc123'));
    });

    test('thumbnailUrl is null when youtubeUrl is null', () {
      final noVideo = Talk(
        id: 'talk-2',
        title: 'No Video Yet',
        date: DateTime(2026, 2, 3),
        speakers: const [],
      );
      expect(noVideo.thumbnailUrl, isNull);
    });
  });

  group('CommunityLinks', () {
    test('constructs correctly', () {
      const links = testCommunityLinks;
      expect(links.slackInviteUrl, startsWith('https://'));
      expect(links.meetupUrl, startsWith('https://'));
    });
  });

  group('Company', () {
    test('constructs with all required fields', () {
      const company = Company(
        name: 'iO',
        logoUrl: '/assets/logos/io.svg',
        websiteUrl: 'https://iodigital.com',
      );
      expect(company.name, 'iO');
      expect(company.logoUrl, '/assets/logos/io.svg');
      expect(company.websiteUrl, 'https://iodigital.com');
    });
  });

  group('Testimonial', () {
    test('constructs with text and Person author', () {
      const t = Testimonial(
        text: 'Great meetup!',
        author: Person(
          id: 'p1',
          name: 'Jan Peeters',
          avatarUrl: '/avatar.jpg',
          companies: [
            PersonCompany(
                name: 'iO', jobTitle: 'Flutter Developer', isActive: true)
          ],
          socialLinks: PersonSocialLinks(),
        ),
      );
      expect(t.text, 'Great meetup!');
      expect(t.author.name, 'Jan Peeters');
      expect(t.author.activeCompany?.name, 'iO');
    });
  });

  group('TeamMember', () {
    test('constructs with required fields, optional fields default to null',
        () {
      const member = TeamMember(
        name: 'Koen Van Looveren',
        role: 'Organiser',
        avatarUrl: 'https://i.pravatar.cc/150?u=koen',
      );
      expect(member.name, 'Koen Van Looveren');
      expect(member.role, 'Organiser');
      expect(member.avatarUrl, startsWith('https://'));
      expect(member.linkedinUrl, isNull);
      expect(member.githubUrl, isNull);
    });
  });

  group('Sponsor', () {
    test('constructs with all required fields', () {
      const sponsor = Sponsor(
        name: 'diskwriter',
        logoUrl: '/assets/company/diskwriter.svg',
        websiteUrl: 'https://diskwriter.be',
      );
      expect(sponsor.name, 'diskwriter');
      expect(sponsor.logoUrl, '/assets/company/diskwriter.svg');
      expect(sponsor.websiteUrl, startsWith('https://'));
    });
  });
}
