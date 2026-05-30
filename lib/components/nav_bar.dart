import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_data/flutter_belgium_data.dart';

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
                src: '/assets/logo-horizontal.svg',
                alt: 'Flutter Belgium',
                classes: 'navbar-logo-img')
          ],
          href: '/',
          classes: 'navbar-logo',
        ),
        nav(classes: 'navbar-links', [
          a([Component.text('About')], href: '#about', classes: 'navbar-link'),
          a([Component.text('Meetups')],
              href: '/meetups', classes: 'navbar-link'),
          a([Component.text('Talks')], href: '/talks', classes: 'navbar-link'),
          div(classes: 'navbar-dropdown', [
            a(
              [Component.text('Made in (Flutter) Belgium')],
              href: '/made-in-flutter-belgium/apps',
              classes: 'navbar-link',
            ),
            div(classes: 'navbar-dropdown-menu', [
              a(
                [Component.text('Apps')],
                href: '/made-in-flutter-belgium/apps',
                classes: 'navbar-dropdown-item',
              ),
              a(
                [Component.text('Companies')],
                href: '/made-in-flutter-belgium/companies',
                classes: 'navbar-dropdown-item',
              ),
              a(
                [Component.text('Developers')],
                href: '/made-in-flutter-belgium/developers',
                classes: 'navbar-dropdown-item',
              ),
            ]),
          ]),
          a(
            [Component.text('Join Flutter Belgium')],
            href: '/#join',
            classes: 'navbar-cta',
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
            href: '/meetups', classes: 'navbar-mobile-link'),
        a([Component.text('Talks')],
            href: '/talks', classes: 'navbar-mobile-link'),
        span(
            classes: 'navbar-mobile-section',
            [const Component.text('Made in')]),
        a(
          [Component.text('Apps')],
          href: '/made-in-flutter-belgium/apps',
          classes: 'navbar-mobile-link navbar-mobile-sublink',
        ),
        a(
          [Component.text('Companies')],
          href: '/made-in-flutter-belgium/companies',
          classes: 'navbar-mobile-link navbar-mobile-sublink',
        ),
        a(
          [Component.text('Developers')],
          href: '/made-in-flutter-belgium/developers',
          classes: 'navbar-mobile-link navbar-mobile-sublink',
        ),
        a(
          [Component.text('Join Flutter Belgium')],
          href: '/#join',
          classes: 'navbar-mobile-cta',
        ),
      ]),
    ]);
  }
}
