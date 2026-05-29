import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../data/models/testimonial.dart';

class TestimonialsSection extends StatelessComponent {
  const TestimonialsSection({required this.testimonials, super.key});

  final List<Testimonial> testimonials;

  @override
  Component build(BuildContext context) {
    final mid = (testimonials.length / 2).ceil();
    final row1 = testimonials.sublist(0, mid);
    final row2 = testimonials.sublist(mid);

    return section(classes: 'testimonials', [
      div(classes: 'testimonials-header container', [
        div(classes: 'testimonials-header-row', [
          div(classes: 'testimonials-header-text', [
            p(classes: 'section-label', [Component.text('Community')]),
            h2(classes: 'section-title',
                [Component.text('What Flutter Belgium members say')]),
          ]),
          a(
            [
              div(classes: 'rating-stars', [Component.text('★★★★★')]),
              div(classes: 'rating-meta', [
                span(classes: 'rating-score', [Component.text('4.7')]),
                span(classes: 'rating-divider', [Component.text('/5')]),
                span(classes: 'rating-count', [Component.text('· 128 reviews on Meetup')]),
              ]),
            ],
            href: 'https://www.meetup.com/flutter-belgium/',
            classes: 'rating-badge',
            attributes: {'target': '_blank', 'rel': 'noopener noreferrer', 'aria-label': '4.7 out of 5 — 128 reviews on Meetup'},
          ),
        ]),
      ]),
      div(classes: 'testimonials-rows', [
        _row(row1, '500s', 'left'),
        _row(row2, '500s', 'right'),
      ]),
    ]);
  }

  Component _row(List<Testimonial> items, String duration, String direction) {
    final doubled = [for (var i = 0; i < 20; i++) ...items];
    return div(classes: 'testimonials-row', [
      div(
        classes: 'testimonial-track-h testimonial-track-h-$direction',
        attributes: {'style': '--duration: $duration'},
        [
          for (final t in doubled) _card(t),
        ],
      ),
    ]);
  }

  Component _card(Testimonial testimonial) {
    return div(classes: 'testimonial-card', [
      p(classes: 'testimonial-text', [Component.text(testimonial.text)]),
      div(classes: 'testimonial-author', [
        if (testimonial.authorAvatarUrl != null)
          img(
            src: testimonial.authorAvatarUrl!,
            alt: testimonial.authorName,
            classes: 'testimonial-avatar',
          )
        else
          div(classes: 'testimonial-avatar-placeholder', [
            img(
              src: '/assets/logo-mark-white.svg',
              alt: '',
              classes: 'testimonial-avatar-placeholder-icon',
            ),
          ]),
        div(classes: 'testimonial-author-info', [
          p(classes: 'testimonial-name',
              [Component.text(testimonial.authorName)]),
          p(classes: 'testimonial-role',
              [Component.text(testimonial.authorRole)]),
        ]),
      ]),
    ]);
  }
}
