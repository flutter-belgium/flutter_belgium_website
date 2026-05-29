import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/models/community_links.dart';

class NavBar extends StatelessComponent {
  const NavBar({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return header(classes: 'navbar', [
      input(
        type: InputType.checkbox,
        id: 'nav-mobile-toggle',
        classes: 'nav-mobile-toggle-input',
      ),
      div(classes: 'navbar-inner container', [
        a(
          [
            img(
                src: '/assets/logo-default.svg',
                alt: 'Flutter Belgium',
                classes: 'navbar-logo-img')
          ],
          href: '/',
          classes: 'navbar-logo',
        ),
        nav(classes: 'navbar-links', [
          a([Component.text('About')], href: '#about', classes: 'navbar-link'),
          a([Component.text('Meetups')],
              href: '#meetups', classes: 'navbar-link'),
          a([Component.text('Talks')], href: '#talks', classes: 'navbar-link'),
          a([Component.text('Join')], href: '#join', classes: 'navbar-link'),
          a(
            [Component.text('Join Slack')],
            href: communityLinks.slackInviteUrl,
            classes: 'navbar-cta',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
          ),
        ]),
        label(
          [span([]), span([]), span([])],
          htmlFor: 'nav-mobile-toggle',
          classes: 'nav-hamburger',
          attributes: {'aria-label': 'Toggle navigation menu'},
        ),
      ]),
      div(classes: 'navbar-mobile-menu', [
        a([Component.text('About')],
            href: '#about', classes: 'navbar-mobile-link'),
        a([Component.text('Meetups')],
            href: '#meetups', classes: 'navbar-mobile-link'),
        a([Component.text('Talks')],
            href: '#talks', classes: 'navbar-mobile-link'),
        a([Component.text('Join')],
            href: '#join', classes: 'navbar-mobile-link'),
        a(
          [Component.text('Join Slack')],
          href: communityLinks.slackInviteUrl,
          classes: 'navbar-mobile-cta',
          attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
        ),
      ]),
    ]);
  }
}
