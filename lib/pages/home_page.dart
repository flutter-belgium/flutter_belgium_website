import 'package:jaspr/jaspr.dart';

import '../components/about_section.dart';
import '../components/footer.dart';
import '../components/hero_section.dart';
import '../components/hosting_companies_section.dart';
import '../components/join_section.dart';
import '../components/nav_bar.dart';
import '../components/next_meetup_section.dart';
import '../components/past_meetups_section.dart';
import '../components/sponsor_section.dart';
import '../components/talks_section.dart';
import '../components/team_section.dart';
import '../components/testimonials_section.dart';
import '../data/models/community_links.dart';
import '../data/models/company.dart';
import '../data/models/meetup.dart';
import '../data/models/sponsor.dart';
import '../data/models/talk.dart';
import '../data/models/team_member.dart';
import '../data/models/testimonial.dart';

class HomePage extends StatelessComponent {
  const HomePage({
    required this.nextMeetup,
    required this.pastMeetups,
    required this.talks,
    required this.communityLinks,
    required this.companies,
    required this.testimonials,
    required this.members,
    required this.sponsors,
    super.key,
  });

  final Meetup? nextMeetup;
  final List<Meetup> pastMeetups;
  final List<Talk> talks;
  final CommunityLinks communityLinks;
  final List<Company> companies;
  final List<Testimonial> testimonials;
  final List<TeamMember> members;
  final List<Sponsor> sponsors;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      HeroSection(communityLinks: communityLinks),
      const AboutSection(),
      TeamSection(members: members),
      NextMeetupSection(meetup: nextMeetup, communityLinks: communityLinks),
      HostingCompaniesSection(companies: companies),
      PastMeetupsSection(
          meetups: pastMeetups, meetupGroupUrl: communityLinks.meetupUrl),
      TalksSection(talks: talks),
      TestimonialsSection(testimonials: testimonials),
      JoinSection(communityLinks: communityLinks),
      SponsorSection(
          sponsors: sponsors, contactUrl: communityLinks.slackInviteUrl),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
