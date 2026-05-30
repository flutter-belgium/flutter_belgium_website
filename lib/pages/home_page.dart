import 'package:jaspr/jaspr.dart';

import 'package:flutter_belgium_website/components/about_section.dart';
import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/hero_section.dart';
import 'package:flutter_belgium_website/components/hosting_companies_section.dart';
import 'package:flutter_belgium_website/components/join_section.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_website/components/next_meetup_section.dart';
import 'package:flutter_belgium_website/components/past_meetups_section.dart';
import 'package:flutter_belgium_website/components/sponsor_section.dart';
import 'package:flutter_belgium_website/components/talks_section.dart';
import 'package:flutter_belgium_website/components/team_section.dart';
import 'package:flutter_belgium_website/components/testimonials_section.dart';
import 'package:flutter_belgium_website/data/models/community_links.dart';
import 'package:flutter_belgium_website/data/models/company.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';
import 'package:flutter_belgium_website/data/models/meetup.dart';
import 'package:flutter_belgium_website/data/models/sponsor.dart';
import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/data/models/team_member.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';

class HomePage extends StatelessComponent {
  const HomePage({
    required this.upcomingMeetups,
    required this.pastMeetups,
    required this.talks,
    required this.communityLinks,
    required this.companies,
    required this.testimonials,
    required this.members,
    required this.sponsors,
    required this.latestMadeInApps,
    super.key,
  });

  final List<Meetup> upcomingMeetups;
  final List<Meetup> pastMeetups;
  final List<Talk> talks;
  final CommunityLinks communityLinks;
  final List<Company> companies;
  final List<Testimonial> testimonials;
  final List<TeamMember> members;
  final List<Sponsor> sponsors;
  final List<MadeInApp> latestMadeInApps;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      HeroSection(communityLinks: communityLinks),
      AboutSection(
          latestApps: latestMadeInApps, madeInUrl: communityLinks.madeInUrl),
      NextMeetupSection(meetups: upcomingMeetups),
      HostingCompaniesSection(companies: companies),
      PastMeetupsSection(meetups: pastMeetups),
      TalksSection(talks: talks),
      SponsorSection(
          sponsors: sponsors, contactUrl: communityLinks.slackInviteUrl),
      TeamSection(members: members),
      TestimonialsSection(testimonials: testimonials),
      JoinSection(communityLinks: communityLinks),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
