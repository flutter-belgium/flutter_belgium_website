import '../models/community_links.dart';
import '../models/company.dart';
import '../models/meetup.dart';
import '../models/speaker.dart';
import '../models/sponsor.dart';
import '../models/talk.dart';
import '../models/team_member.dart';
import '../models/testimonial.dart';
import 'flutter_belgium_repository.dart';

class MockFlutterBelgiumRepository implements FlutterBelgiumRepository {
  static final List<Meetup> _pastMeetups = [
    Meetup(
        id: 'meetup-1',
        title: 'Flutter Belgium #1',
        date: DateTime(2023, 11, 16),
        hostCompany: 'iO',
        location: 'Ghent',
        thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/'),
    Meetup(
        id: 'meetup-2',
        title: 'Flutter Belgium #2',
        date: DateTime(2024, 2, 22),
        hostCompany: 'Zimmo',
        location: 'Antwerp',
        thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/'),
    Meetup(
        id: 'meetup-3',
        title: 'Flutter Belgium #3',
        date: DateTime(2024, 5, 30),
        hostCompany: 'Cegeka',
        location: 'Hasselt',
        thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/'),
  ];

  static final List<Talk> _talks = [
    const Talk(
        id: 'talk-1',
        title: 'Getting Started with Flutter',
        speaker: Speaker(
            name: 'Jan Peeters', jobTitle: 'Flutter Developer', company: 'iO'),
        meetupId: 'meetup-1',
        meetupTitle: 'Flutter Belgium #1',
        youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnailUrl: '/assets/talk/flutter_belgium_talk.jpeg'),
    const Talk(
        id: 'talk-2',
        title: 'State Management in 2024',
        speaker: Speaker(
            name: 'Lisa Maes', jobTitle: 'Senior Developer', company: 'Zimmo'),
        meetupId: 'meetup-2',
        meetupTitle: 'Flutter Belgium #2',
        youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnailUrl: '/assets/talk/flutter_belgium_talk.jpeg'),
    const Talk(
        id: 'talk-3',
        title: 'Flutter Web in Production',
        speaker: Speaker(
            name: 'Tom Claes', jobTitle: 'Lead Engineer', company: 'Cegeka'),
        meetupId: 'meetup-3',
        meetupTitle: 'Flutter Belgium #3',
        youtubeUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
        thumbnailUrl: '/assets/talk/flutter_belgium_talk.jpeg'),
    const Talk(
        id: 'talk-4',
        title: 'Custom Painters Deep Dive',
        speaker: Speaker(name: 'An Willems', company: 'Freelance'),
        meetupId: 'meetup-3',
        meetupTitle: 'Flutter Belgium #3',
        thumbnailUrl: '/assets/talk/flutter_belgium_talk.jpeg'),
  ];

  static const List<Company> _companies = [
    Company(
      name: 'Flutter Belgium',
      logoUrl: '/assets/logo-default.svg',
      websiteUrl: 'https://flutterbelgium.be',
    ),
  ];

  static const List<Sponsor> _sponsors = [
    Sponsor(
      name: 'impaktfull',
      logoUrl: '/assets/company/impaktfull.svg',
      websiteUrl: 'https://impaktfull.com',
    ),
    Sponsor(
      name: 'diskwriter',
      logoUrl: '/assets/company/diskwriter.svg',
      websiteUrl: 'https://diskwriter.be',
    ),
  ];

  static const List<TeamMember> _teamMembers = [
    TeamMember(
      name: 'Koen Van Looveren',
      role: 'Organiser',
      avatarUrl: '/assets/team/koen.jpeg',
      githubUrl: 'https://github.com/vanlooverenkoen',
      linkedinUrl: 'https://www.linkedin.com/in/koenvanlooveren/',
    ),
    TeamMember(
      name: 'Jens Gyselinck',
      role: 'Organiser',
      avatarUrl: '/assets/team/jens.jpeg',
      linkedinUrl: 'https://www.linkedin.com/in/jensgyselinck/',
      githubUrl: 'https://github.com/diskwriter',
    ),
    TeamMember(
      name: 'Kris Pypen',
      role: 'Organiser',
      avatarUrl: '/assets/team/kris.jpeg',
      linkedinUrl: 'https://www.linkedin.com/in/krispypen/',
      githubUrl: 'https://github.com/krispypen',
    ),
  ];

  static const List<Testimonial> _testimonials = [
    Testimonial(
      text:
          'Building Flutter Belgium has been one of the most rewarding things I have done as a developer. Seeing the community grow and watching people connect over a shared passion for Flutter makes every event worth it.',
      authorName: 'Koen Van Looveren',
      authorRole: 'Organiser at Flutter Belgium',
    ),
    Testimonial(
      text:
          'I joined as an organiser because I wanted to give back to the community that helped me grow as an engineer. Flutter Belgium is the place where Belgian Flutter developers come to learn and inspire each other.',
      authorName: 'Jens Gyselinck',
      authorRole: 'Organiser at Flutter Belgium',
    ),
    Testimonial(
      text:
          'What started as a small idea has grown into a thriving community of Flutter developers across Belgium. The conversations and connections that happen at every meetup continue to surprise and motivate me.',
      authorName: 'Kris Pypen',
      authorRole: 'Organiser at Flutter Belgium',
    ),
  ];

  @override
  Future<Meetup?> getNextMeetup() async => Meetup(
      id: 'meetup-next',
      title: 'Flutter Belgium #4',
      date: DateTime(2024, 9, 19),
      hostCompany: 'Cronos',
      location: 'Leuven',
      thumbnailUrl: '/assets/meetup/flutter-belgium-meetup.avif',
      meetupUrl: 'https://www.meetup.com/flutter-belgium/events/314638952');

  @override
  Future<List<Meetup>> getPastMeetups() async =>
      List.unmodifiable(_pastMeetups);

  @override
  Future<List<Talk>> getAllTalks() async => List.unmodifiable(_talks);

  @override
  Future<CommunityLinks> getCommunityLinks() async => const CommunityLinks(
        slackInviteUrl:
            'https://join.slack.com/t/flutter-belgium/shared_invite/zt-2w7m73ron-5NZWiebmvxXAzBairbAisw',
        youtubeChannelUrl: 'https://www.youtube.com/@flutter-belgium',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/',
        linkedinUrl: 'https://www.linkedin.com/company/flutter-belgium/',
        githubUrl: 'https://github.com/flutter-belgium',
        madeInUrl: 'https://madein.flutterbelgium.be',
      );

  @override
  Future<List<Company>> getHostingCompanies() async =>
      List.unmodifiable(_companies);

  @override
  Future<List<Testimonial>> getTestimonials() async =>
      List.unmodifiable(_testimonials);

  @override
  Future<List<TeamMember>> getTeamMembers() async =>
      List.unmodifiable(_teamMembers);

  @override
  Future<List<Sponsor>> getSponsors() async =>
      List.unmodifiable(_sponsors);
}
