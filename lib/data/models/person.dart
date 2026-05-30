import 'package:flutter_belgium_website/data/models/person_company.dart';
import 'package:flutter_belgium_website/data/models/person_social_links.dart';

class Person {
  const Person({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.companies,
    this.githubUsername,
    required this.socialLinks,
  });
  final String id;
  final String name;
  final String avatarUrl;
  // Must be a const list literal at call sites to keep the Person instance const.
  final List<PersonCompany> companies;
  final String? githubUsername;
  final PersonSocialLinks socialLinks;

  PersonCompany? get activeCompany {
    final matches = companies.where((c) => c.isActive);
    return matches.isEmpty ? null : matches.first;
  }
}
