import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'package:flutter_belgium_data/flutter_belgium_data.dart';
import 'package:flutter_belgium_website/data/repositories/mock_flutter_belgium_repository.dart';
import 'package:flutter_belgium_website/main.server.options.dart';
import 'package:flutter_belgium_website/pages/branding_page.dart';
import 'package:flutter_belgium_website/pages/home_page.dart';
import 'package:flutter_belgium_website/pages/made_in_flutter_belgium/made_in_app_detail_page.dart';
import 'package:flutter_belgium_website/pages/made_in_flutter_belgium/made_in_apps_page.dart';
import 'package:flutter_belgium_website/pages/made_in_flutter_belgium/made_in_companies_page.dart';
import 'package:flutter_belgium_website/pages/made_in_flutter_belgium/made_in_company_detail_page.dart';
import 'package:flutter_belgium_website/pages/made_in_flutter_belgium/made_in_developer_detail_page.dart';
import 'package:flutter_belgium_website/pages/made_in_flutter_belgium/made_in_developers_page.dart';
import 'package:flutter_belgium_website/pages/meetups/meetup_detail_page.dart';
import 'package:flutter_belgium_website/pages/meetups/meetups_page.dart';
import 'package:flutter_belgium_website/pages/talks/talks_page.dart';
import 'package:flutter_belgium_website/pages/app_page.dart';
import 'package:flutter_belgium_website/pages/become_a_sponsor_page.dart';
import 'package:flutter_belgium_website/pages/privacy_policy_page.dart';
import 'package:flutter_belgium_website/pages/not_found_page.dart';
import 'package:flutter_belgium_website/pages/review_page.dart';
import 'package:flutter_belgium_website/pages/stats_page.dart';
import 'package:flutter_belgium_website/pages/scan_page.dart';
import 'package:flutter_belgium_website/pages/terms_page.dart';
import 'package:flutter_belgium_website/util/shuffle_utils.dart';

// To switch to the real API package, replace MockFlutterBelgiumRepository
// with ApiFlutterBelgiumRepository from the published Dart package,
// then delete lib/data/models/ and lib/data/repositories/mock_*.dart.
void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  final repository = MockFlutterBelgiumRepository();

  final upcomingMeetups = await repository.getUpcomingMeetups();
  print('[DATA] Upcoming meetups: ${upcomingMeetups.length}');
  final pastMeetups = await repository.getPastMeetups();
  print('[DATA] Past meetups: ${pastMeetups.length}');
  final allMeetups = [...upcomingMeetups, ...pastMeetups];
  print('[DATA] All meetups (combined): ${allMeetups.length}');
  final talks = await repository.getAllTalks();
  print('[DATA] Talks: ${talks.length}');
  final communityLinks = await repository.getCommunityLinks();
  print('[DATA] CommunityLinks loaded');
  final companies = await repository.getHostingCompanies();
  print('[DATA] Companies: ${companies.length}');
  final testimonials = shuffleNoAdjacentDuplicates(
    await repository.getTestimonials(),
    (t) => t.author.name,
  );
  print('[DATA] Testimonials: ${testimonials.length}');
  final teamMembers = await repository.getTeamMembers();
  print('[DATA] Team members: ${teamMembers.length}');
  final sponsors = await repository.getSponsors();
  print('[DATA] Sponsors: ${sponsors.length}');

  final flutterBelgiumData = FlutterBelgiumData();
  final madeInApps = await flutterBelgiumData.getMadeInApps();
  print('[DATA] MadeIn Apps: ${madeInApps.length}');
  final madeInCompanies = await flutterBelgiumData.getMadeInCompanies();
  print('[DATA] MadeIn Companies: ${madeInCompanies.length}');
  final madeInDevelopers =
      ([...await flutterBelgiumData.getMadeInDevelopers()]..sort((dev1, dev2) {
          final nameA = (dev1.name ?? dev1.githubUserName).toLowerCase();
          final nameB = (dev2.name ?? dev2.githubUserName).toLowerCase();
          return nameA.compareTo(nameB);
        }));
  print('[DATA] MadeIn Developers: ${madeInDevelopers.length}');
  final latestApps = shuffleNoAdjacentDuplicates(madeInApps, (app) => app.name);
  print('[DATA] Latest shuffled MadeIn Apps: ${latestApps.length}');

  runApp(Document(
    title: 'Flutter Belgium',
    lang: 'en',
    meta: {
      'description':
          'Flutter Belgium: the Belgian Flutter community. Meetups, talks, and a Slack community for Flutter developers in Belgium.',
    },
    head: [
      link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      link(
          rel: 'preconnect',
          href: 'https://fonts.gstatic.com',
          attributes: {'crossorigin': ''}),
      link(
        rel: 'stylesheet',
        href:
            'https://fonts.googleapis.com/css2?family=Google+Sans+Flex:ital,opsz,wght@0,12..72,100..900;1,12..72,100..900&display=swap',
      ),
      link(rel: 'stylesheet', href: 'styles.css'),
      link(rel: 'icon', type: 'image/svg+xml', href: 'assets/logo-mark.svg'),
      script(src: 'nav.js', defer: true),
    ],
    body: Router(routes: [
      Route(
        path: '/',
        title: 'Flutter Belgium',
        settings:
            const RouteSettings(changeFreq: ChangeFreq.weekly, priority: 1.0),
        builder: (context, state) => HomePage(
          upcomingMeetups: upcomingMeetups.take(3).toList(),
          pastMeetups: pastMeetups.take(3).toList(),
          talks: talks.take(3).toList(),
          communityLinks: communityLinks,
          companies: companies,
          testimonials: testimonials,
          members: teamMembers,
          sponsors: sponsors,
          latestMadeInApps: latestApps,
        ),
      ),
      Route(
        path: '/privacy',
        title: 'Privacy Policy | Flutter Belgium',
        builder: (context, state) =>
            PrivacyPolicyPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/terms',
        title: 'Terms & Conditions | Flutter Belgium',
        builder: (context, state) => TermsPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/branding',
        title: 'Branding | Flutter Belgium',
        builder: (context, state) =>
            BrandingPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/app',
        title: 'Flutter Belgium App',
        builder: (context, state) => AppPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/scan',
        title: 'Flutter Belgium',
        builder: (context, state) => ScanPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/review',
        title: 'Review | Flutter Belgium',
        builder: (context, state) => ReviewPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/stats',
        title: 'Community Stats | Flutter Belgium',
        settings:
            const RouteSettings(changeFreq: ChangeFreq.daily, priority: 0.7),
        builder: (context, state) => StatsPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/not-found',
        title: 'Page Not Found | Flutter Belgium',
        builder: (context, state) =>
            NotFoundPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/become-a-sponsor',
        title: 'Become a Sponsor | Flutter Belgium',
        settings:
            const RouteSettings(changeFreq: ChangeFreq.monthly, priority: 0.7),
        builder: (context, state) =>
            BecomeASponsorPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/meetups',
        title: 'Meetups | Flutter Belgium',
        settings:
            const RouteSettings(changeFreq: ChangeFreq.weekly, priority: 0.9),
        builder: (context, state) => MeetupsPage(
          upcomingMeetups: upcomingMeetups,
          pastMeetups: pastMeetups,
          communityLinks: communityLinks,
        ),
      ),
      for (final meetup in allMeetups)
        Route(
          path: '/meetups/${meetup.slug}',
          title: '${meetup.title} | Flutter Belgium',
          settings: const RouteSettings(
              changeFreq: ChangeFreq.monthly, priority: 0.8),
          builder: (context, state) => MeetupDetailPage(
            meetup: meetup,
            communityLinks: communityLinks,
          ),
        ),
      Route(
        path: '/talks',
        title: 'Talks | Flutter Belgium',
        settings:
            const RouteSettings(changeFreq: ChangeFreq.weekly, priority: 0.8),
        builder: (context, state) => TalksPage(
          talks: talks,
          communityLinks: communityLinks,
        ),
      ),
      Route(
        path: '/made-in-flutter-belgium/apps',
        title: 'Apps | Made in Flutter Belgium',
        settings:
            const RouteSettings(changeFreq: ChangeFreq.weekly, priority: 0.9),
        builder: (context, state) => MadeInAppsPage(
          apps: madeInApps,
          communityLinks: communityLinks,
        ),
      ),
      Route(
        path: '/made-in-flutter-belgium/companies',
        title: 'Companies | Made in Flutter Belgium',
        settings:
            const RouteSettings(changeFreq: ChangeFreq.weekly, priority: 0.9),
        builder: (context, state) => MadeInCompaniesPage(
          companies: madeInCompanies,
          communityLinks: communityLinks,
        ),
      ),
      Route(
        path: '/made-in-flutter-belgium/developers',
        title: 'Developers | Made in Flutter Belgium',
        settings:
            const RouteSettings(changeFreq: ChangeFreq.weekly, priority: 0.9),
        builder: (context, state) => MadeInDevelopersPage(
          developers: madeInDevelopers,
          communityLinks: communityLinks,
        ),
      ),
      for (final app in madeInApps)
        Route(
          path: '/made-in-flutter-belgium/apps/${toSlug(app.name)}',
          title: '${app.name} | Made in Flutter Belgium',
          builder: (context, state) => MadeInAppDetailPage(
            app: app,
            communityLinks: communityLinks,
          ),
        ),
      for (final company in madeInCompanies)
        Route(
          path: '/made-in-flutter-belgium/companies/${toSlug(company.name)}',
          title: '${company.name} | Made in Flutter Belgium',
          builder: (context, state) => MadeInCompanyDetailPage(
            company: company,
            communityLinks: communityLinks,
          ),
        ),
      for (final developer in madeInDevelopers)
        Route(
          path:
              '/made-in-flutter-belgium/developers/${toSlug(developer.githubUserName)}',
          title:
              '${developer.name ?? developer.githubUserName} | Made in Flutter Belgium',
          builder: (context, state) => MadeInDeveloperDetailPage(
            developer: developer,
            communityLinks: communityLinks,
          ),
        ),
    ]),
  ));
}
