import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'data/repositories/mock_flutter_belgium_repository.dart';
import 'main.server.options.dart';
import 'pages/branding_page.dart';
import 'pages/home_page.dart';
import 'pages/privacy_policy_page.dart';
import 'pages/terms_page.dart';

// To switch to the real API package, replace MockFlutterBelgiumRepository
// with ApiFlutterBelgiumRepository from the published Dart package,
// then delete lib/data/models/ and lib/data/repositories/mock_*.dart.
void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  final repository = MockFlutterBelgiumRepository();

  final nextMeetup = await repository.getNextMeetup();
  final pastMeetups = await repository.getPastMeetups();
  final talks = await repository.getAllTalks();
  final communityLinks = await repository.getCommunityLinks();
  final companies = await repository.getHostingCompanies();
  final testimonials = await repository.getTestimonials();
  final teamMembers = await repository.getTeamMembers();
  final sponsors = await repository.getSponsors();

  runApp(Document(
    title: 'Flutter Belgium',
    lang: 'en',
    meta: {
      'description':
          'Flutter Belgium: the Belgian Flutter community. Meetups, talks, and a Slack community for Flutter developers in Belgium.',
    },
    head: [
      link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      link(rel: 'preconnect', href: 'https://fonts.gstatic.com',
          attributes: {'crossorigin': ''}),
      link(
        rel: 'stylesheet',
        href: 'https://fonts.googleapis.com/css2?family=Google+Sans+Flex:ital,opsz,wght@0,12..72,100..900;1,12..72,100..900&display=swap',
      ),
      link(rel: 'stylesheet', href: 'styles.css'),
      link(rel: 'icon', type: 'image/svg+xml', href: 'assets/logo-mark.svg'),
    ],
    body: Router(routes: [
      Route(
        path: '/',
        title: 'Flutter Belgium',
        builder: (context, state) => HomePage(
          nextMeetup: nextMeetup,
          pastMeetups: pastMeetups,
          talks: talks,
          communityLinks: communityLinks,
          companies: companies,
          testimonials: testimonials,
          members: teamMembers,
          sponsors: sponsors,
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
        builder: (context, state) =>
            TermsPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/branding',
        title: 'Branding | Flutter Belgium',
        builder: (context, state) =>
            BrandingPage(communityLinks: communityLinks),
      ),
    ]),
  ));
}
