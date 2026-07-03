import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/person.dart';
import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';
import 'package:flutter_belgium_website/data/models/sponsor.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/models/team_member.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';
import 'package:flutter_belgium_website/data/repositories/flutter_belgium_repository.dart';

class MockFlutterBelgiumRepository implements FlutterBelgiumRepository {
  static const _koen = Person(
    id: 'person-koen',
    name: 'Koen Van Looveren',
    avatarUrl: '/assets/team/koen.jpeg',
    companies: [
      PersonCompany(
          name: 'impaktfull',
          jobTitle: 'Founder & Flutter Developer',
          isActive: true),
    ],
    githubUsername: 'vanlooverenkoen',
    socialLinks: PersonSocialLinks(
      githubUrl: 'https://github.com/vanlooverenkoen',
      linkedinUrl: 'https://www.linkedin.com/in/koenvanlooveren/',
    ),
  );

  static const _jens = Person(
    id: 'person-jens',
    name: 'Jens Gyselinck',
    avatarUrl: '/assets/team/jens.jpeg',
    companies: [
      PersonCompany(
          name: 'diskwriter',
          jobTitle: 'Founder & Flutter Developer',
          isActive: true),
    ],
    githubUsername: 'diskwriter',
    socialLinks: PersonSocialLinks(
      githubUrl: 'https://github.com/diskwriter',
      linkedinUrl: 'https://www.linkedin.com/in/jensgyselinck/',
    ),
  );

  static const _kris = Person(
    id: 'person-kris',
    name: 'Kris Pypen',
    avatarUrl: '/assets/team/kris.jpeg',
    companies: [
      PersonCompany(
          name: 'Flutter Belgium', jobTitle: 'Organiser', isActive: true),
    ],
    githubUsername: 'krispypen',
    socialLinks: PersonSocialLinks(
      githubUrl: 'https://github.com/krispypen',
      linkedinUrl: 'https://www.linkedin.com/in/krispypen/',
    ),
  );

  static const _gaganDeepSingh = Person(
    id: 'person-gagan-deep-singh',
    name: 'Gagan Deep Singh',
    avatarUrl: '/assets/testimonials/gagan-deep-singh.jpeg',
    companies: [
      PersonCompany(
          name: 'Barco', jobTitle: 'Fullstack Engineer', isActive: true),
    ],
    socialLinks: PersonSocialLinks(),
  );

  static const _freDumazy = Person(
    id: 'person-fre-dumazy',
    name: 'Fré Dumazy',
    avatarUrl: '/assets/testimonials/fre-dumazy.jpeg',
    companies: [
      PersonCompany(
          name: 'Skystone Apps',
          jobTitle: 'Freelance App Developer',
          isActive: true),
    ],
    socialLinks: PersonSocialLinks(),
  );

  static const _williamVerhaeghe = Person(
    id: 'person-william-verhaeghe',
    name: 'William Verhaeghe',
    avatarUrl: '/assets/testimonials/william-verhaeghe.jpeg',
    companies: [
      PersonCompany(
          name: 'Lightning Development', jobTitle: 'Freelance', isActive: true),
    ],
    socialLinks: PersonSocialLinks(),
  );

  static const _yarnoVanDeWeyer = Person(
    id: 'person-yarno-van-de-weyer',
    name: 'Yarno Van de Weyer',
    avatarUrl: '/assets/testimonials/yarno-van-de-weyer.jpeg',
    companies: [
      PersonCompany(
          name: 'm-Path Software', jobTitle: 'App Developer', isActive: true),
    ],
    socialLinks: PersonSocialLinks(),
  );

  static final List<Meetup> _allMeetups = [
    Meetup(
      id: 'meetup-3',
      title: 'Flutter Belgium #26',
      date: DateTime(2026, 2, 3),
      hostCompany: 'ACA Group',
      location: 'Gent',
      thumbnailUrl: '/assets/meetup/meetup_26.avif',
      meetupUrl: 'https://www.meetup.com/flutter-belgium/events/312351623',
      talks: [
        Talk(
          id: 'talk-1',
          title: 'Building performant Flutter apps',
          date: DateTime(2026, 2, 3),
          youtubeUrl: 'https://www.youtube.com/watch?v=1bM6JiwLMX0',
          speakers: const [_koen],
        ),
      ],
      description:
          'ACA Group hosts our 26th edition in Gent. An evening packed with Flutter talks, networking, and community vibes. Whether you\'re a seasoned Flutter developer or just getting started, everyone is welcome!\n\nProgram:\n18:00 — Doors open\n18:30 — Lightning Talks\n19:00 — <session-1>\n19:45 — <session-2>\n21:00 — Networking',
    ),
    Meetup(
      id: 'meetup-2',
      title: 'Flutter Belgium #25',
      date: DateTime(2025, 10, 8),
      hostCompany: 'icapps',
      location: 'Antwerp',
      thumbnailUrl: '/assets/meetup/meetup_25.avif',
      meetupUrl: 'https://www.meetup.com/flutter-belgium/events/306394784',
      talks: [
        Talk(
          id: 'talk-2',
          title: 'State management in 2025',
          date: DateTime(2025, 10, 8),
          youtubeUrl: 'https://www.youtube.com/watch?v=iQQhv72eYRA',
          speakers: const [_jens],
        ),
      ],
      description:
          'icapps welcomes the Flutter Belgium community to Antwerp for our 25th meetup. Expect inspiring talks, good food, and great people. A milestone edition celebrating 25 Flutter Belgium meetups together!\n\nProgram:\n18:00 — Doors open\n18:30 — Lightning Talks\n19:00 — <session-1>\n19:45 — <session-2>\n21:00 — Networking',
    ),
    Meetup(
      id: 'meetup-1',
      title: 'Flutter Belgium #24',
      date: DateTime(2025, 6, 11),
      hostCompany: 'MobileGeneration',
      location: 'Brussels',
      thumbnailUrl: '/assets/meetup/meetup_24.avif',
      meetupUrl: 'https://www.meetup.com/flutter-belgium/events/306394783',
      talks: [
        Talk(
          id: 'talk-3',
          title: 'Flutter for desktop',
          date: DateTime(2025, 6, 11),
          youtubeUrl: 'https://www.youtube.com/watch?v=J08BJIVDucI',
          speakers: const [_kris],
        ),
      ],
      description:
          'MobileGeneration hosts our summer edition in Brussels. A perfect evening to catch up with the community before the holiday season. Flutter talks, networking, and the usual warm Flutter Belgium atmosphere.\n\nProgram:\n18:00 — Doors open\n18:30 — Lightning Talks\n19:00 — <session-1>\n19:45 — <session-2>\n21:00 — Networking',
    ),
    Meetup(
      id: 'meetup-next',
      title: 'Flutter Belgium #27',
      date: DateTime(2026, 6, 3),
      hostCompany: 'Aaltra',
      location: 'Melle',
      thumbnailUrl: '/assets/meetup/meetup_27.avif',
      meetupUrl: 'https://www.meetup.com/flutter-belgium/events/314638952',
      description:
          'Aaltra organizes the Flutter Belgium Meetup #27. Are you a Flutter expert or just curious about what Flutter is? Everybody is welcome!\n\nProgram:\n18:00 — Doors open\n18:30 — Lightning Talks\n19:00 — <session-1>\n19:45 — <session-2>\n21:00 — Networking',
    ),
  ];

  static const List<Person> _persons = [_koen, _jens, _kris];

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
      author: _koen,
    ),
    Testimonial(
      text:
          'I joined as an organiser because I wanted to give back to the community that helped me grow as an engineer. Flutter Belgium is the place where Belgian Flutter developers come to learn and inspire each other.',
      author: _jens,
    ),
    Testimonial(
      text:
          'What started as a small idea has grown into a thriving community of Flutter developers across Belgium. The conversations and connections that happen at every meetup continue to surprise and motivate me.',
      author: _kris,
    ),
    Testimonial(
      text:
          'This was my first time attending the event#27 on 3 Jun 2026 as Aaltra, but I didn\'t feel like a stranger for a single moment. The hosts were fantastic, ensuring everyone was warmly welcomed and fully included. I\'m already looking forward to the next one!',
      author: _gaganDeepSingh,
    ),
    Testimonial(
      text:
          'Flutter Belgium has done an great job at bringing the Belgian community together. By moving the meetups from city to city, they\'ve allowed newcomers to easily join and give everyone a chance to speak in front of an audience. Combining the in-person meetups with a high quality live stream really pushes it to the next level.',
      author: _freDumazy,
    ),
    Testimonial(
      text:
          'Flutter Belgium is the perfect place to meet both new people and skilled developers. Every meetup is different and always a good way to encounter different views or how to solve problems you will encounter in the future.',
      author: _williamVerhaeghe,
    ),
    Testimonial(
      text:
          'I really enjoy going to these meetups. The talks are always interesting (duh). But the community itself is the best part: welcoming, knowledgeable, and just very nice people to be around. And as a bonus, the food is great too. Highly recommend if you\'re into Flutter/Dart development and want to connect with others in the space.',
      author: _yarnoVanDeWeyer,
    ),
  ];

  @override
  Future<Meetup?> getNextMeetup() async {
    final upcoming = await getUpcomingMeetups();
    return upcoming.isEmpty ? null : upcoming.first;
  }

  @override
  Future<List<Meetup>> getUpcomingMeetups() async {
    final now = DateTime.now();
    return List.unmodifiable(
      ([..._allMeetups]
        ..removeWhere((m) => m.date.isBefore(now))
        ..sort((a, b) => a.date.compareTo(b.date))),
    );
  }

  @override
  Future<List<Meetup>> getPastMeetups() async {
    final now = DateTime.now();
    return List.unmodifiable(
      ([..._allMeetups]
        ..removeWhere((m) => !m.date.isBefore(now))
        ..sort((a, b) => b.date.compareTo(a.date))),
    );
  }

  @override
  Future<Meetup?> getMeetupBySlug(String slug) async {
    try {
      return _allMeetups.firstWhere((m) => m.slug == slug);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Person>> getPersons() async => List.unmodifiable(_persons);

  @override
  Future<List<Talk>> getAllTalks() async {
    final allTalks = _allMeetups.expand((m) => m.talks).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return List.unmodifiable(allTalks);
  }

  @override
  Future<CommunityLinks> getCommunityLinks() async => const CommunityLinks(
        slackInviteUrl:
            'https://join.slack.com/t/flutter-belgium/shared_invite/zt-2w7m73ron-5NZWiebmvxXAzBairbAisw',
        youtubeChannelUrl: 'https://www.youtube.com/@flutter-belgium',
        meetupUrl: 'https://www.meetup.com/flutter-belgium/',
        linkedinUrl: 'https://www.linkedin.com/company/flutter-belgium/',
        instagramUrl: 'https://www.instagram.com/flutterbelgium/',
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
