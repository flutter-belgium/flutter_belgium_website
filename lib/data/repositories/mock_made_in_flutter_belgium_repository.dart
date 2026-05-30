import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app_links.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company_links.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_developer.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_developer_links.dart';
import 'package:flutter_belgium_website/data/repositories/made_in_flutter_belgium_repository.dart';

class MockMadeInFlutterBelgiumRepository
    implements MadeInFlutterBelgiumRepository {
  static final List<MadeInApp> _apps = [
    MadeInApp(
      name: 'Sample App One',
      localIconPath: 'assets/made_in/projects/Sample App One/app_icon.webp',
      description: 'A sample Flutter app built in Belgium.',
      publisher: 'Sample Co',
      releaseDate: DateTime(2024, 6, 1),
      isSunsetted: false,
      sunsetReason: null,
      links: const MadeInAppLinks(
        appstore: 'https://apps.apple.com',
        playstore: 'https://play.google.com',
      ),
      localBannerPath: null,
      screenshotPaths: const [],
      developers: const [],
      involvedCompanies: const [],
    ),
    MadeInApp(
      name: 'Sample App Two',
      localIconPath: 'assets/made_in/projects/Sample App Two/app_icon.webp',
      description: 'Another sample Flutter app.',
      publisher: null,
      releaseDate: DateTime(2024, 9, 15),
      isSunsetted: false,
      sunsetReason: null,
      links: const MadeInAppLinks(),
      localBannerPath: null,
      screenshotPaths: const [],
      developers: const [],
      involvedCompanies: const [],
    ),
    MadeInApp(
      name: 'Sample App Three',
      localIconPath: 'assets/made_in/projects/Sample App Three/app_icon.webp',
      description: 'Third sample app — now sunset.',
      publisher: 'Third Co',
      releaseDate: DateTime(2025, 1, 20),
      isSunsetted: true,
      sunsetReason: 'Discontinued by publisher.',
      links: const MadeInAppLinks(),
      localBannerPath: null,
      screenshotPaths: const [],
      developers: const [],
      involvedCompanies: const [],
    ),
  ];

  static const List<MadeInCompany> _companies = [
    MadeInCompany(
      name: 'Sample Agency',
      localLogoPath: 'assets/made_in/companies/Sample Agency/logo.svg',
      useLogoInsteadOfTextTitle: true,
      description: 'A sample agency building Flutter apps.',
      links: MadeInCompanyLinks(
        website: 'https://sample-agency.be',
        jobWebsite: 'https://jobs.sample-agency.be',
      ),
      isAgency: true,
      developers: [],
      projects: [],
      involvedProjects: [],
    ),
    MadeInCompany(
      name: 'Sample Studio',
      localLogoPath: 'assets/made_in/companies/Sample Studio/logo.webp',
      useLogoInsteadOfTextTitle: false,
      description: 'A design and development studio.',
      links: null,
      isAgency: false,
      developers: [],
      projects: [],
      involvedProjects: [],
    ),
    MadeInCompany(
      name: 'Sample Corp',
      localLogoPath: 'assets/made_in/companies/Sample Corp/logo.svg',
      useLogoInsteadOfTextTitle: false,
      description: null,
      links: MadeInCompanyLinks(website: 'https://samplecorp.be'),
      isAgency: false,
      developers: [],
      projects: [],
      involvedProjects: [],
    ),
  ];

  static const List<MadeInDeveloper> _developers = [
    MadeInDeveloper(
      githubUserName: 'sampledev1',
      name: 'Sample Developer One',
      localAvatarPath: 'assets/made_in/developers/sampledev1/avatar.jpg',
      description: 'A Belgian Flutter developer.',
      links: MadeInDeveloperLinks(
        linkedin: 'https://linkedin.com/in/sampledev1',
        personalWebsite: 'https://sampledev1.be',
      ),
      projects: [],
    ),
    MadeInDeveloper(
      githubUserName: 'sampledev2',
      name: null,
      localAvatarPath: 'assets/made_in/developers/sampledev2/avatar.jpg',
      description: null,
      links: null,
      projects: [],
    ),
    MadeInDeveloper(
      githubUserName: 'sampledev3',
      name: 'Sample Developer Three',
      localAvatarPath: 'assets/made_in/developers/sampledev3/avatar.jpg',
      description: 'Third developer.',
      links: null,
      projects: [],
    ),
  ];

  @override
  Future<List<MadeInApp>> getApps() async => List.unmodifiable(_apps);

  @override
  Future<List<MadeInCompany>> getCompanies() async =>
      List.unmodifiable(_companies);

  @override
  Future<List<MadeInDeveloper>> getDevelopers() async =>
      List.unmodifiable(_developers);
}
