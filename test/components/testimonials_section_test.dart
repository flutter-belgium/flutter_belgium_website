import 'package:flutter_belgium_website/components/testimonials_section.dart';
import 'package:flutter_belgium_data/flutter_belgium_data.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  const testimonials = [
    Testimonial(
      text: 'Flutter Belgium is a great community.',
      author: Person(
        id: 'p1',
        name: 'Kris Pypen',
        avatarUrl: '/assets/team/kris.jpeg',
        companies: [
          PersonCompany(
              name: 'Flutter Belgium', jobTitle: 'Organiser', isActive: true)
        ],
        socialLinks: PersonSocialLinks(),
      ),
    ),
    Testimonial(
      text: 'Every edition is a great opportunity to learn.',
      author: Person(
        id: 'p2',
        name: 'Koen Van Looveren',
        avatarUrl: '/assets/team/koen.jpeg',
        companies: [
          PersonCompany(
              name: 'impaktfull',
              jobTitle: 'Founder & Flutter Developer',
              isActive: true)
        ],
        socialLinks: PersonSocialLinks(),
      ),
    ),
    Testimonial(
      text: 'We started this because we love the community.',
      author: Person(
        id: 'p3',
        name: 'Jens Gyselinck',
        avatarUrl: '/assets/team/jens.jpeg',
        companies: [
          PersonCompany(
              name: 'diskwriter',
              jobTitle: 'Founder & Flutter Developer',
              isActive: true)
        ],
        socialLinks: PersonSocialLinks(),
      ),
    ),
  ];

  testComponents(
      'TestimonialsSection renders section label, title, and two scroll rows',
      (tester) async {
    tester.pumpComponent(const TestimonialsSection(testimonials: testimonials));
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

  testComponents('TestimonialsSection renders author name and company role',
      (tester) async {
    tester.pumpComponent(const TestimonialsSection(testimonials: testimonials));
    // Names appear 20× per row due to track duplication
    expect(find.text('Kris Pypen'), findsNComponents(20));
    expect(find.text('Organiser at Flutter Belgium'), findsNComponents(20));
  });

  testComponents(
      'TestimonialsSection omits role line when author has no active company',
      (tester) async {
    const noCompanyTestimonial = Testimonial(
      text: 'No company here.',
      author: Person(
        id: 'p-no-co',
        name: 'Anonymous',
        avatarUrl: '/avatar.jpg',
        companies: [],
        socialLinks: PersonSocialLinks(),
      ),
    );
    tester.pumpComponent(
        const TestimonialsSection(testimonials: [noCompanyTestimonial]));
    expect(
      find.byComponentPredicate(
        (c) =>
            c is DomComponent &&
            (c.classes?.contains('testimonial-role') ?? false),
      ),
      findsNothing,
    );
  });
}
