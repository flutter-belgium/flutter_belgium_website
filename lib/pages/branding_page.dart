import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import 'package:flutter_belgium_website/components/footer.dart';
import 'package:flutter_belgium_website/components/nav_bar.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';

class BrandingPage extends StatelessComponent {
  const BrandingPage({required this.communityLinks, super.key});

  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'branding', [
        div(classes: 'branding-inner container', [
          div(classes: 'branding-header', [
            p(classes: 'section-label', [const Component.text('Resources')]),
            h1(classes: 'section-title', [const Component.text('Branding')]),
            p(classes: 'section-body', [
              const Component.text(
                  'Official Flutter Belgium logos and brand assets. Use these to represent Flutter Belgium in your content, event materials, and communications.'),
            ]),
          ]),

          // Color logos
          h2(
              classes: 'branding-section-title',
              [const Component.text('Color logos')]),
          div(classes: 'branding-grid', [
            _logoCard(
              src: '/assets/logo-default.svg',
              label: 'Logo — Default',
              filename: 'logo-default.svg',
              dark: false,
            ),
            _logoCard(
              src: '/assets/logo-horizontal.svg',
              label: 'Logo — Horizontal',
              filename: 'logo-horizontal.svg',
              dark: false,
            ),
            _logoCard(
              src: '/assets/logo-mark.svg',
              label: 'Logomark — Color',
              filename: 'logo-mark.svg',
              dark: false,
            ),
          ]),

          // White logos
          h2(
              classes: 'branding-section-title',
              [const Component.text('White logos')]),
          div(classes: 'branding-grid', [
            _logoCard(
              src: '/assets/logo-full-white.svg',
              label: 'Logo — Full White',
              filename: 'logo-full-white.svg',
              dark: true,
            ),
            _logoCard(
              src: '/assets/logo-white.svg',
              label: 'Logo — White',
              filename: 'logo-white.svg',
              dark: true,
              sky: true,
            ),
            _logoCard(
              src: '/assets/logo-mark-white.svg',
              label: 'Logomark — White',
              filename: 'logo-mark-white.svg',
              dark: true,
            ),
          ]),

          // Colors
          h2(
              classes: 'branding-section-title',
              [const Component.text('Brand colors')]),
          div(classes: 'branding-colors', [
            _colorSwatch(
                name: 'Navy', hex: '#021F40', classes: 'branding-swatch-navy'),
            _colorSwatch(
                name: 'Sky', hex: '#027DFD', classes: 'branding-swatch-sky'),
            _colorSwatch(
                name: 'Yellow',
                hex: '#FFD648',
                classes: 'branding-swatch-yellow'),
            _colorSwatch(
                name: 'Yellow Light',
                hex: '#FFF275',
                classes: 'branding-swatch-yellow-light'),
            _colorSwatch(
                name: 'Red', hex: '#F25D50', classes: 'branding-swatch-red'),
            _colorSwatch(
                name: 'Grey', hex: '#E6EDFF', classes: 'branding-swatch-grey'),
          ]),
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }

  Component _logoCard({
    required String src,
    required String label,
    required String filename,
    required bool dark,
    bool sky = false,
  }) {
    final bg = sky
        ? 'branding-card-sky'
        : (dark ? 'branding-card-dark' : 'branding-card-light');
    return div(classes: 'branding-card $bg', [
      div(classes: 'branding-card-preview', [
        img(src: src, alt: label, classes: 'branding-logo-img'),
      ]),
      div(classes: 'branding-card-footer', [
        span(classes: 'branding-card-label', [Component.text(label)]),
        a(
          [const Component.text('Download')],
          href: src,
          classes: 'branding-download-btn',
          attributes: {'download': filename},
        ),
      ]),
    ]);
  }

  Component _colorSwatch({
    required String name,
    required String hex,
    required String classes,
  }) {
    return div(classes: 'branding-swatch $classes', [
      div(classes: 'branding-swatch-color', []),
      div(classes: 'branding-swatch-info', [
        span(classes: 'branding-swatch-name', [Component.text(name)]),
        span(classes: 'branding-swatch-hex', [Component.text(hex)]),
      ]),
    ]);
  }
}
