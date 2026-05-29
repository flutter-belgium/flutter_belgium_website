import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/speaker.dart';
import 'package:flutter_belgium_website/data/models/sponsor.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/models/team_member.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';
import 'package:test/test.dart';

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
  });

  group('Talk', () {
    test('constructs with required fields, youtubeUrl defaults to null', () {
      const talk = Talk(
        id: 't1',
        title: 'Building with Flutter',
        speaker: Speaker(name: 'Jane Doe'),
        meetupId: '1',
        meetupTitle: 'Flutter Belgium #1',
      );
      expect(talk.youtubeUrl, isNull);
      expect(talk.meetupTitle, 'Flutter Belgium #1');
    });
  });

  group('CommunityLinks', () {
    test('constructs correctly', () {
      const links = CommunityLinks(
        slackInviteUrl: 'https://slack.com/invite/xxx',
        youtubeChannelUrl: 'https://youtube.com/@flutter-belgium',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/',
        linkedinUrl: 'https://www.linkedin.com/company/flutter-belgium/',
        githubUrl: 'https://github.com/flutter-belgium',
        madeInUrl: 'https://madein.flutterbelgium.be',
      );
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
    test('constructs with all required fields', () {
      const t = Testimonial(
        text: 'Great meetup!',
        authorName: 'Jan Peeters',
        authorRole: 'Flutter Developer at iO',
        authorAvatarUrl: 'https://i.pravatar.cc/80?img=1',
      );
      expect(t.text, 'Great meetup!');
      expect(t.authorName, 'Jan Peeters');
      expect(t.authorRole, 'Flutter Developer at iO');
      expect(t.authorAvatarUrl, 'https://i.pravatar.cc/80?img=1');
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
