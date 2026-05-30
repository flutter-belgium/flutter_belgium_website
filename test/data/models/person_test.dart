import 'package:flutter_belgium_data/flutter_belgium_data.dart';
import 'package:test/test.dart';

void main() {
  group('PersonSocialLinks', () {
    test('all fields optional, defaults to null', () {
      const links = PersonSocialLinks();
      expect(links.githubUrl, isNull);
      expect(links.linkedinUrl, isNull);
      expect(links.twitterUrl, isNull);
      expect(links.websiteUrl, isNull);
    });

    test('constructs with provided fields', () {
      const links = PersonSocialLinks(
        githubUrl: 'https://github.com/test',
        linkedinUrl: 'https://linkedin.com/in/test',
      );
      expect(links.githubUrl, 'https://github.com/test');
      expect(links.twitterUrl, isNull);
    });
  });

  group('PersonCompany', () {
    test('constructs with isActive true', () {
      const c = PersonCompany(
        name: 'Acme',
        jobTitle: 'Flutter Developer',
        isActive: true,
      );
      expect(c.name, 'Acme');
      expect(c.jobTitle, 'Flutter Developer');
      expect(c.isActive, isTrue);
    });

    test('constructs with isActive false', () {
      const c = PersonCompany(
        name: 'Old Corp',
        jobTitle: 'Dev',
        isActive: false,
      );
      expect(c.isActive, isFalse);
    });
  });

  group('Person', () {
    const activeCompany = PersonCompany(
      name: 'impaktfull',
      jobTitle: 'Founder',
      isActive: true,
    );
    const inactiveCompany = PersonCompany(
      name: 'Old Corp',
      jobTitle: 'Dev',
      isActive: false,
    );
    const person = Person(
      id: 'p1',
      name: 'Koen Van Looveren',
      avatarUrl: '/assets/team/koen.jpeg',
      companies: [inactiveCompany, activeCompany],
      githubUsername: 'vanlooverenkoen',
      socialLinks: PersonSocialLinks(
        githubUrl: 'https://github.com/vanlooverenkoen',
      ),
    );

    test('constructs with all fields', () {
      expect(person.id, 'p1');
      expect(person.name, 'Koen Van Looveren');
      expect(person.githubUsername, 'vanlooverenkoen');
    });

    test('activeCompany returns the first isActive company', () {
      expect(person.activeCompany, activeCompany);
    });

    test('activeCompany returns null when no active company', () {
      const p = Person(
        id: 'p2',
        name: 'No Active',
        avatarUrl: '/avatar.jpg',
        companies: [inactiveCompany],
        socialLinks: PersonSocialLinks(),
      );
      expect(p.activeCompany, isNull);
    });

    test('activeCompany returns null when companies is empty', () {
      const p = Person(
        id: 'p3',
        name: 'Empty',
        avatarUrl: '/avatar.jpg',
        companies: [],
        socialLinks: PersonSocialLinks(),
      );
      expect(p.activeCompany, isNull);
    });

    test('githubUsername is optional', () {
      const p = Person(
        id: 'p4',
        name: 'No GitHub',
        avatarUrl: '/avatar.jpg',
        companies: [],
        socialLinks: PersonSocialLinks(),
      );
      expect(p.githubUsername, isNull);
    });
  });
}
