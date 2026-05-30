import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/sponsor.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/models/team_member.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';
import 'package:flutter_belgium_website/data/repositories/flutter_belgium_repository.dart';

class MockFlutterBelgiumRepository implements FlutterBelgiumRepository {
  static final List<Meetup> _pastMeetups = [
    Meetup(
        id: 'meetup-3',
        title: 'Flutter Belgium #26',
        date: DateTime(2026, 2, 3),
        hostCompany: 'ACA Group',
        location: 'Gent',
        thumbnailUrl: '/assets/meetup/meetup_26.avif',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/events/312351623'),
    Meetup(
        id: 'meetup-2',
        title: 'Flutter Belgium #25',
        date: DateTime(2025, 10, 8),
        hostCompany: 'icapps',
        location: 'Antwerp',
        thumbnailUrl: '/assets/meetup/meetup_25.avif',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/events/306394784'),
    Meetup(
        id: 'meetup-1',
        title: 'Flutter Belgium #24',
        date: DateTime(2025, 6, 11),
        hostCompany: 'MobileGeneration',
        location: 'Brussels',
        thumbnailUrl: '/assets/meetup/meetup_24.avif',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/events/306394783'),
  ];

  static const List<Talk> _talks = [
    Talk(youtubeUrl: 'https://www.youtube.com/watch?v=1bM6JiwLMX0'),
    Talk(youtubeUrl: 'https://www.youtube.com/watch?v=iQQhv72eYRA'),
    Talk(youtubeUrl: 'https://www.youtube.com/watch?v=J08BJIVDucI'),
  ];

  static const List<Company> _companies = [
    Company(
      name: 'In The Pocket',
      logoUrl: '/assets/company/in_the_pocket.svg',
      websiteUrl: 'https://www.inthepocket.com',
    ),
    Company(
      name: 'Lemon',
      logoUrl: '/assets/company/lemon.webp',
      websiteUrl: 'https://lemon.be',
    ),
    Company(
      name: 'Get Driven',
      logoUrl: '/assets/company/get_driven.webp',
      websiteUrl: 'https://getdriven.be',
    ),
    Company(
      name: 'Aaltra',
      logoUrl: '/assets/company/aaltra.webp',
      websiteUrl: 'https://aaltra.com',
    ),
    Company(
      name: 'Make it Fly',
      logoUrl: '/assets/company/make_it_fly.svg',
      websiteUrl: 'https://makeitfly.be',
    ),
    Company(
      name: 'icapps',
      logoUrl: '/assets/company/icapps.svg',
      websiteUrl: 'https://icapps.com',
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
      authorAvatarUrl: '/assets/team/koen.jpeg',
    ),
    Testimonial(
      text:
          'I joined as an organiser because I wanted to give back to the community that helped me grow as an engineer. Flutter Belgium is the place where Belgian Flutter developers come to learn and inspire each other.',
      authorName: 'Jens Gyselinck',
      authorRole: 'Organiser at Flutter Belgium',
      authorAvatarUrl: '/assets/team/jens.jpeg',
    ),
    Testimonial(
      text:
          'What started as a small idea has grown into a thriving community of Flutter developers across Belgium. The conversations and connections that happen at every meetup continue to surprise and motivate me.',
      authorName: 'Kris Pypen',
      authorRole: 'Organiser at Flutter Belgium',
      authorAvatarUrl: '/assets/team/kris.jpeg',
    ),
  ];

  @override
  Future<Meetup?> getNextMeetup() async => Meetup(
      id: 'meetup-next',
      title: 'Flutter Belgium #4',
      date: DateTime(2024, 9, 19),
      hostCompany: 'Cronos',
      location: 'Leuven',
      thumbnailUrl: '/assets/meetup/meetup_27.avif',
      meetupUrl: 'https://www.meetup.com/flutter-belgium/events/314638952');

  @override
  Future<List<Meetup>> getPastMeetups() async {
    final sorted = [..._pastMeetups]..sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(sorted);
  }

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
        madeInUrl: '/made-in-flutter-belgium/apps',
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
  Future<List<Sponsor>> getSponsors() async => List.unmodifiable(_sponsors);
}
