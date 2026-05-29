import 'package:flutter_belgium_website/components/testimonials_section.dart';
import 'package:flutter_belgium_website/data/models/testimonial.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const testimonials = [
    Testimonial(
      text: 'Flutter Belgium is a great community.',
      authorName: 'Kris Pypen',
      authorRole: 'Organiser at Flutter Belgium',
    ),
    Testimonial(
      text: 'Every edition is a great opportunity to learn.',
      authorName: 'Koen Van Looveren',
      authorRole: 'Organiser at Flutter Belgium',
    ),
    Testimonial(
      text: 'We started this because we love the community.',
      authorName: 'Jens Gyselinck',
      authorRole: 'Organiser at Flutter Belgium',
    ),
  ];

  testComponents(
      'TestimonialsSection renders section label, title, and two scroll rows',
      (tester) async {
    tester.pumpComponent(
        const TestimonialsSection(testimonials: testimonials));
    expect(find.tag('section'), findsOneComponent);
    expect(find.text('Community'), findsOneComponent);
    expect(find.text('What Flutter Belgium members say'), findsOneComponent);
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('testimonials-rows') ?? false),
      ),
      findsOneComponent,
    );
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('testimonial-track-h') ?? false),
      ),
      findsNComponents(2),
    );
  });
}
