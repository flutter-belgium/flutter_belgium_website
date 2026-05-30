# Made in Flutter Belgium Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a "Made in Flutter Belgium" section to the Jaspr website — three tab pages (apps/companies/developers) with individual detail pages, a home-page showcase of the 5 latest apps, and CI image downloading to avoid external image dependencies.

**Architecture:** Data is fetched from `api.madein.flutterbelgium.be` at `jaspr build` time (all info.jsons in parallel); image URLs are mapped to local asset paths; a Python CI script downloads all images before the build runs. The mock repository supplies local-dev data; the HTTP repository is used in CI/production.

**Tech Stack:** Dart/Jaspr, `dart:io` + `dart:convert` (no new packages), Python 3 (CI script), GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-05-29-made-in-flutter-belgium-design.md`

---

## File Map

**New files — utilities/models/repositories:**
- `lib/util/made_in_utils.dart` — `toLocalImagePath()` and `toSlug()` pure functions
- `lib/data/models/made_in_flutter_belgium/made_in_app_links.dart`
- `lib/data/models/made_in_flutter_belgium/made_in_company_links.dart`
- `lib/data/models/made_in_flutter_belgium/made_in_developer_links.dart`
- `lib/data/models/made_in_flutter_belgium/made_in_app_ref.dart`
- `lib/data/models/made_in_flutter_belgium/made_in_company_ref.dart`
- `lib/data/models/made_in_flutter_belgium/made_in_developer_ref.dart`
- `lib/data/models/made_in_flutter_belgium/made_in_app.dart`
- `lib/data/models/made_in_flutter_belgium/made_in_company.dart`
- `lib/data/models/made_in_flutter_belgium/made_in_developer.dart`
- `lib/data/repositories/made_in_flutter_belgium_repository.dart`
- `lib/data/repositories/mock_made_in_flutter_belgium_repository.dart`
- `lib/data/repositories/http_made_in_flutter_belgium_repository.dart`

**New files — components/pages:**
- `lib/components/made_in_flutter_belgium/made_in_card.dart`
- `lib/components/made_in_flutter_belgium/made_in_page_shell.dart`
- `lib/components/made_in_flutter_belgium/made_in_showcase_section.dart`
- `lib/pages/made_in_flutter_belgium/made_in_apps_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_companies_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_developers_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_app_detail_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_company_detail_page.dart`
- `lib/pages/made_in_flutter_belgium/made_in_developer_detail_page.dart`

**New files — CI:**
- `.github/workflows/scripts/download_made_in_images.py`

**New files — tests:**
- `test/util/made_in_utils_test.dart`
- `test/data/models/made_in_models_test.dart`
- `test/data/repositories/mock_made_in_repository_test.dart`
- `test/components/made_in_card_test.dart`
- `test/components/made_in_page_shell_test.dart`
- `test/components/made_in_showcase_section_test.dart`

**Modified files:**
- `.gitignore` — add `web/assets/made_in/`
- `.github/workflows/deploy.yml` — add download step before jaspr build
- `web/styles.css` — add made-in CSS rules
- `lib/main.server.dart` — add routes + data fetching
- `lib/pages/home_page.dart` — add `latestMadeInApps` param + `MadeInShowcaseSection`
- `lib/components/footer.dart` — change madeInUrl link to internal (no `target="_blank"`)
- `lib/data/repositories/mock_flutter_belgium_repository.dart` — update `madeInUrl` to internal path

---

## Task 1: Utilities — toLocalImagePath and toSlug

**Files:**
- Create: `lib/util/made_in_utils.dart`
- Create: `test/util/made_in_utils_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `test/util/made_in_utils_test.dart`:

```dart
import 'package:flutter_belgium_website/util/made_in_utils.dart';
import 'package:test/test.dart';

void main() {
  group('toLocalImagePath', () {
    test('converts API project image URL to local asset path', () {
      expect(
        toLocalImagePath(
            'https://api.madein.flutterbelgium.be/projects/Bevoy/images/app_icon.webp'),
        'assets/made_in/projects/Bevoy/app_icon.webp',
      );
    });

    test('converts API project URL with spaces in name', () {
      expect(
        toLocalImagePath(
            'https://api.madein.flutterbelgium.be/projects/Covid Safe/images/app_icon.webp'),
        'assets/made_in/projects/Covid Safe/app_icon.webp',
      );
    });

    test('converts API company logo URL — preserves svg extension', () {
      expect(
        toLocalImagePath(
            'https://api.madein.flutterbelgium.be/companies/ACA Group/images/logo.svg'),
        'assets/made_in/companies/ACA Group/logo.svg',
      );
    });

    test('converts API company logo URL — preserves webp extension', () {
      expect(
        toLocalImagePath(
            'https://api.madein.flutterbelgium.be/companies/Aaltra/images/logo.webp'),
        'assets/made_in/companies/Aaltra/logo.webp',
      );
    });

    test('converts API screenshot URL', () {
      expect(
        toLocalImagePath(
            'https://api.madein.flutterbelgium.be/projects/Covid Safe/images/screenshot_1.webp'),
        'assets/made_in/projects/Covid Safe/screenshot_1.webp',
      );
    });

    test('converts GitHub avatar URL to local developer avatar path', () {
      expect(
        toLocalImagePath('https://avatars.githubusercontent.com/vanlooverenkoen'),
        'assets/made_in/developers/vanlooverenkoen/avatar.jpg',
      );
    });

    test('returns url unchanged when it is not a known host', () {
      expect(
        toLocalImagePath('https://example.com/image.png'),
        'https://example.com/image.png',
      );
    });
  });

  group('toSlug', () {
    test('lowercases a simple name', () {
      expect(toSlug('Bevoy'), 'bevoy');
    });

    test('replaces spaces with hyphens', () {
      expect(toSlug('Covid Safe'), 'covid-safe');
    });

    test('strips special characters and replaces spaces', () {
      expect(toSlug('ACA Group'), 'aca-group');
    });

    test('collapses multiple spaces/special chars into a single hyphen', () {
      expect(toSlug('Four In A Row - Classic'), 'four-in-a-row-classic');
    });

    test('handles names that are already lowercase', () {
      expect(toSlug('equipo'), 'equipo');
    });
  });
}
```

- [ ] **Step 2: Run tests to confirm they fail**

```bash
dart test test/util/made_in_utils_test.dart
```

Expected: compile error — `made_in_utils.dart` does not exist yet.

- [ ] **Step 3: Create `lib/util/made_in_utils.dart`**

```dart
String toLocalImagePath(String url) {
  const apiBase = 'https://api.madein.flutterbelgium.be/';
  const githubBase = 'https://avatars.githubusercontent.com/';

  if (url.startsWith(apiBase)) {
    final path = url.substring(apiBase.length);
    return 'assets/made_in/${path.replaceFirst('/images/', '/')}';
  }
  if (url.startsWith(githubBase)) {
    final username = url.substring(githubBase.length);
    return 'assets/made_in/developers/$username/avatar.jpg';
  }
  return url;
}

String toSlug(String name) {
  return name
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
      .replaceAll(RegExp(r'\s+'), '-');
}
```

- [ ] **Step 4: Run tests to confirm they pass**

```bash
dart test test/util/made_in_utils_test.dart
```

Expected: All tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/util/made_in_utils.dart test/util/made_in_utils_test.dart
git commit -m "feat: add made-in URL and slug utility functions"
```

---

## Task 2: Data Models

**Files:**
- Create: `lib/data/models/made_in_flutter_belgium/made_in_app_links.dart`
- Create: `lib/data/models/made_in_flutter_belgium/made_in_company_links.dart`
- Create: `lib/data/models/made_in_flutter_belgium/made_in_developer_links.dart`
- Create: `lib/data/models/made_in_flutter_belgium/made_in_app_ref.dart`
- Create: `lib/data/models/made_in_flutter_belgium/made_in_company_ref.dart`
- Create: `lib/data/models/made_in_flutter_belgium/made_in_developer_ref.dart`
- Create: `lib/data/models/made_in_flutter_belgium/made_in_app.dart`
- Create: `lib/data/models/made_in_flutter_belgium/made_in_company.dart`
- Create: `lib/data/models/made_in_flutter_belgium/made_in_developer.dart`
- Create: `test/data/models/made_in_models_test.dart`

- [ ] **Step 1: Write the failing model tests**

Create `test/data/models/made_in_models_test.dart`:

```dart
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_developer.dart';
import 'package:test/test.dart';

void main() {
  group('MadeInApp.fromJson', () {
    test('parses all fields from Bevoy info.json shape', () {
      final json = {
        'name': 'Bevoy',
        'description': 'A well-being app.',
        'releaseData': '2023-07-04T00:00:00.000',
        'isSunsetted': false,
        'publisher': 'Bevoy',
        'developers': [
          {
            'githubUserName': 'tijlivens',
            'profilePictureUrl':
                'https://avatars.githubusercontent.com/tijlivens',
          }
        ],
        'links': {
          'appstore': 'https://apps.apple.com/be/app/bevoy/id6443584006',
          'playstore': null,
          'webApp': null,
          'marketingWebsite': 'https://bevoy.be',
          'youTube': null,
          'demoYouTubeVideo': null,
          'openSourceCode': null,
        },
        'sunsetReason': null,
        'images': {
          'appIconUrl':
              'https://api.madein.flutterbelgium.be/projects/Bevoy/images/app_icon.webp',
          'screenshotUrls': [
            'https://api.madein.flutterbelgium.be/projects/Bevoy/images/screenshot_1.webp',
          ],
          'companyLogoUrl': null,
          'bannerUrl':
              'https://api.madein.flutterbelgium.be/projects/Bevoy/images/banner.webp',
        },
        'involvedCompanies': [
          {
            'name': 'Lemon',
            'logoUrl':
                'https://api.madein.flutterbelgium.be/companies/Lemon/images/logo.webp',
            'useLogoInsteadOfTextTitle': true,
          }
        ],
      };

      final app = MadeInApp.fromJson(json);

      expect(app.name, 'Bevoy');
      expect(app.description, 'A well-being app.');
      expect(app.releaseDate, DateTime(2023, 7, 4));
      expect(app.isSunsetted, false);
      expect(app.publisher, 'Bevoy');
      expect(app.localIconPath, 'assets/made_in/projects/Bevoy/app_icon.webp');
      expect(app.localBannerPath, 'assets/made_in/projects/Bevoy/banner.webp');
      expect(app.screenshotPaths,
          ['assets/made_in/projects/Bevoy/screenshot_1.webp']);
      expect(app.links.appstore,
          'https://apps.apple.com/be/app/bevoy/id6443584006');
      expect(app.links.playstore, isNull);
      expect(app.developers, hasLength(1));
      expect(app.developers.first.githubUserName, 'tijlivens');
      expect(app.developers.first.localAvatarPath,
          'assets/made_in/developers/tijlivens/avatar.jpg');
      expect(app.involvedCompanies, hasLength(1));
      expect(app.involvedCompanies.first.name, 'Lemon');
      expect(app.involvedCompanies.first.localLogoPath,
          'assets/made_in/companies/Lemon/logo.webp');
    });

    test('handles null developers and involvedCompanies', () {
      final json = {
        'name': 'Solo App',
        'description': 'Built by one person.',
        'releaseData': '2024-01-01T00:00:00.000',
        'isSunsetted': false,
        'links': {},
        'images': {
          'appIconUrl':
              'https://api.madein.flutterbelgium.be/projects/Solo App/images/app_icon.webp',
        },
      };
      final app = MadeInApp.fromJson(json);
      expect(app.developers, isEmpty);
      expect(app.involvedCompanies, isEmpty);
      expect(app.screenshotPaths, isEmpty);
      expect(app.localBannerPath, isNull);
    });
  });

  group('MadeInCompany.fromJson', () {
    test('parses icapps info.json shape', () {
      final json = {
        'name': 'icapps',
        'useLogoInsteadOfTextTitle': true,
        'description': 'Full-service digital partner.',
        'links': {
          'website': 'https://icapps.com',
          'jobWebsite': 'https://jobs.icapps.com',
        },
        'developers': null,
        'projects': [],
        'involvedProjects': [
          {
            'name': 'Gaia',
            'appIconUrl':
                'https://api.madein.flutterbelgium.be/projects/Gaia/images/app_icon.webp',
          }
        ],
        'images': {
          'logoUrl':
              'https://api.madein.flutterbelgium.be/companies/icapps/images/logo.svg',
        },
        'isAgency': true,
      };

      final company = MadeInCompany.fromJson(json);

      expect(company.name, 'icapps');
      expect(company.useLogoInsteadOfTextTitle, true);
      expect(company.description, 'Full-service digital partner.');
      expect(company.localLogoPath,
          'assets/made_in/companies/icapps/logo.svg');
      expect(company.links!.website, 'https://icapps.com');
      expect(company.links!.jobWebsite, 'https://jobs.icapps.com');
      expect(company.isAgency, true);
      expect(company.developers, isEmpty);
      expect(company.involvedProjects, hasLength(1));
      expect(company.involvedProjects.first.name, 'Gaia');
      expect(company.involvedProjects.first.localIconPath,
          'assets/made_in/projects/Gaia/app_icon.webp');
    });
  });

  group('MadeInDeveloper.fromJson', () {
    test('parses vanlooverenkoen info.json shape', () {
      final json = {
        'githubUserName': 'vanlooverenkoen',
        'name': 'Koen Van Looveren',
        'description': 'Flutter developer.',
        'images': {
          'profilePictureUrl':
              'https://avatars.githubusercontent.com/vanlooverenkoen',
        },
        'links': {
          'linkedin': 'https://linkedin.com/in/vanlooverenkoen/',
          'personalWebsite': 'https://vanlooverenkoen.be',
          'freelanceWebsite': null,
        },
        'projects': [
          {
            'name': 'Gaia',
            'appIconUrl':
                'https://api.madein.flutterbelgium.be/projects/Gaia/images/app_icon.webp',
          }
        ],
      };

      final dev = MadeInDeveloper.fromJson(json);

      expect(dev.githubUserName, 'vanlooverenkoen');
      expect(dev.name, 'Koen Van Looveren');
      expect(dev.description, 'Flutter developer.');
      expect(dev.localAvatarPath,
          'assets/made_in/developers/vanlooverenkoen/avatar.jpg');
      expect(dev.links!.linkedin,
          'https://linkedin.com/in/vanlooverenkoen/');
      expect(dev.links!.personalWebsite, 'https://vanlooverenkoen.be');
      expect(dev.links!.freelanceWebsite, isNull);
      expect(dev.projects, hasLength(1));
      expect(dev.projects.first.name, 'Gaia');
    });

    test('handles missing optional name and links', () {
      final json = {
        'githubUserName': 'aaltrarjen',
        'images': {
          'profilePictureUrl':
              'https://avatars.githubusercontent.com/aaltrarjen',
        },
      };
      final dev = MadeInDeveloper.fromJson(json);
      expect(dev.name, isNull);
      expect(dev.links, isNull);
      expect(dev.projects, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run tests to confirm they fail**

```bash
dart test test/data/models/made_in_models_test.dart
```

Expected: compile error — model files do not exist yet.

- [ ] **Step 3: Create link models**

`lib/data/models/made_in_flutter_belgium/made_in_app_links.dart`:
```dart
class MadeInAppLinks {
  const MadeInAppLinks({
    this.appstore,
    this.playstore,
    this.webApp,
    this.marketingWebsite,
    this.youTube,
    this.demoYouTubeVideo,
    this.openSourceCode,
  });

  final String? appstore;
  final String? playstore;
  final String? webApp;
  final String? marketingWebsite;
  final String? youTube;
  final String? demoYouTubeVideo;
  final String? openSourceCode;

  factory MadeInAppLinks.fromJson(Map<String, dynamic> json) => MadeInAppLinks(
        appstore: json['appstore'] as String?,
        playstore: json['playstore'] as String?,
        webApp: json['webApp'] as String?,
        marketingWebsite: json['marketingWebsite'] as String?,
        youTube: json['youTube'] as String?,
        demoYouTubeVideo: json['demoYouTubeVideo'] as String?,
        openSourceCode: json['openSourceCode'] as String?,
      );
}
```

`lib/data/models/made_in_flutter_belgium/made_in_company_links.dart`:
```dart
class MadeInCompanyLinks {
  const MadeInCompanyLinks({required this.website, this.jobWebsite});

  final String website;
  final String? jobWebsite;

  factory MadeInCompanyLinks.fromJson(Map<String, dynamic> json) =>
      MadeInCompanyLinks(
        website: json['website'] as String,
        jobWebsite: json['jobWebsite'] as String?,
      );
}
```

`lib/data/models/made_in_flutter_belgium/made_in_developer_links.dart`:
```dart
class MadeInDeveloperLinks {
  const MadeInDeveloperLinks({
    this.linkedin,
    this.personalWebsite,
    this.freelanceWebsite,
  });

  final String? linkedin;
  final String? personalWebsite;
  final String? freelanceWebsite;

  factory MadeInDeveloperLinks.fromJson(Map<String, dynamic> json) =>
      MadeInDeveloperLinks(
        linkedin: json['linkedin'] as String?,
        personalWebsite: json['personalWebsite'] as String?,
        freelanceWebsite: json['freelanceWebsite'] as String?,
      );
}
```

- [ ] **Step 4: Create ref models**

`lib/data/models/made_in_flutter_belgium/made_in_app_ref.dart`:
```dart
import '../../../util/made_in_utils.dart';

class MadeInAppRef {
  const MadeInAppRef({required this.name, required this.localIconPath});

  final String name;
  final String localIconPath;

  factory MadeInAppRef.fromJson(Map<String, dynamic> json) => MadeInAppRef(
        name: json['name'] as String,
        localIconPath: toLocalImagePath(json['appIconUrl'] as String? ?? ''),
      );
}
```

`lib/data/models/made_in_flutter_belgium/made_in_company_ref.dart`:
```dart
import '../../../util/made_in_utils.dart';

class MadeInCompanyRef {
  const MadeInCompanyRef({
    required this.name,
    required this.localLogoPath,
    required this.useLogoInsteadOfTextTitle,
  });

  final String name;
  final String localLogoPath;
  final bool useLogoInsteadOfTextTitle;

  factory MadeInCompanyRef.fromJson(Map<String, dynamic> json) =>
      MadeInCompanyRef(
        name: json['name'] as String,
        localLogoPath: toLocalImagePath(json['logoUrl'] as String? ?? ''),
        useLogoInsteadOfTextTitle:
            json['useLogoInsteadOfTextTitle'] as bool? ?? false,
      );
}
```

`lib/data/models/made_in_flutter_belgium/made_in_developer_ref.dart`:
```dart
import '../../../util/made_in_utils.dart';

class MadeInDeveloperRef {
  const MadeInDeveloperRef({
    required this.githubUserName,
    required this.localAvatarPath,
  });

  final String githubUserName;
  final String localAvatarPath;

  factory MadeInDeveloperRef.fromJson(Map<String, dynamic> json) =>
      MadeInDeveloperRef(
        githubUserName: json['githubUserName'] as String,
        localAvatarPath:
            toLocalImagePath(json['profilePictureUrl'] as String? ?? ''),
      );
}
```

- [ ] **Step 5: Create main models**

`lib/data/models/made_in_flutter_belgium/made_in_app.dart`:
```dart
import '../../../util/made_in_utils.dart';
import 'made_in_app_links.dart';
import 'made_in_company_ref.dart';
import 'made_in_developer_ref.dart';

class MadeInApp {
  const MadeInApp({
    required this.name,
    required this.localIconPath,
    required this.description,
    this.publisher,
    required this.releaseDate,
    required this.isSunsetted,
    this.sunsetReason,
    required this.links,
    this.localBannerPath,
    required this.screenshotPaths,
    required this.developers,
    required this.involvedCompanies,
  });

  final String name;
  final String localIconPath;
  final String description;
  final String? publisher;
  final DateTime releaseDate;
  final bool isSunsetted;
  final String? sunsetReason;
  final MadeInAppLinks links;
  final String? localBannerPath;
  final List<String> screenshotPaths;
  final List<MadeInDeveloperRef> developers;
  final List<MadeInCompanyRef> involvedCompanies;

  factory MadeInApp.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>? ?? {};
    final rawIcon = images['appIconUrl'] as String? ?? '';
    final rawBanner = images['bannerUrl'] as String?;
    final rawScreenshots =
        (images['screenshotUrls'] as List<dynamic>?)?.cast<String>() ?? [];
    final linksJson = json['links'] as Map<String, dynamic>? ?? {};

    return MadeInApp(
      name: json['name'] as String,
      localIconPath: toLocalImagePath(rawIcon),
      description: json['description'] as String? ?? '',
      publisher: json['publisher'] as String?,
      releaseDate: DateTime.parse(json['releaseData'] as String),
      isSunsetted: json['isSunsetted'] as bool? ?? false,
      sunsetReason: json['sunsetReason'] as String?,
      links: MadeInAppLinks.fromJson(linksJson),
      localBannerPath: rawBanner != null ? toLocalImagePath(rawBanner) : null,
      screenshotPaths: rawScreenshots.map(toLocalImagePath).toList(),
      developers: ((json['developers'] as List<dynamic>?) ?? [])
          .map((e) => MadeInDeveloperRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      involvedCompanies: ((json['involvedCompanies'] as List<dynamic>?) ?? [])
          .map((e) => MadeInCompanyRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
```

`lib/data/models/made_in_flutter_belgium/made_in_company.dart`:
```dart
import '../../../util/made_in_utils.dart';
import 'made_in_app_ref.dart';
import 'made_in_company_links.dart';
import 'made_in_developer_ref.dart';

class MadeInCompany {
  const MadeInCompany({
    required this.name,
    required this.localLogoPath,
    required this.useLogoInsteadOfTextTitle,
    this.description,
    this.links,
    required this.isAgency,
    required this.developers,
    required this.projects,
    required this.involvedProjects,
  });

  final String name;
  final String localLogoPath;
  final bool useLogoInsteadOfTextTitle;
  final String? description;
  final MadeInCompanyLinks? links;
  final bool isAgency;
  final List<MadeInDeveloperRef> developers;
  final List<MadeInAppRef> projects;
  final List<MadeInAppRef> involvedProjects;

  factory MadeInCompany.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>? ?? {};
    final rawLogo = images['logoUrl'] as String? ?? '';
    final linksJson = json['links'] as Map<String, dynamic>?;

    return MadeInCompany(
      name: json['name'] as String,
      localLogoPath: toLocalImagePath(rawLogo),
      useLogoInsteadOfTextTitle:
          json['useLogoInsteadOfTextTitle'] as bool? ?? false,
      description: json['description'] as String?,
      links: linksJson != null ? MadeInCompanyLinks.fromJson(linksJson) : null,
      isAgency: json['isAgency'] as bool? ?? false,
      developers: ((json['developers'] as List<dynamic>?) ?? [])
          .map((e) => MadeInDeveloperRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: ((json['projects'] as List<dynamic>?) ?? [])
          .map((e) => MadeInAppRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      involvedProjects: ((json['involvedProjects'] as List<dynamic>?) ?? [])
          .map((e) => MadeInAppRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
```

`lib/data/models/made_in_flutter_belgium/made_in_developer.dart`:
```dart
import '../../../util/made_in_utils.dart';
import 'made_in_app_ref.dart';
import 'made_in_developer_links.dart';

class MadeInDeveloper {
  const MadeInDeveloper({
    required this.githubUserName,
    this.name,
    required this.localAvatarPath,
    this.description,
    this.links,
    required this.projects,
  });

  final String githubUserName;
  final String? name;
  final String localAvatarPath;
  final String? description;
  final MadeInDeveloperLinks? links;
  final List<MadeInAppRef> projects;

  factory MadeInDeveloper.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as Map<String, dynamic>? ?? {};
    final rawAvatar = images['profilePictureUrl'] as String? ?? '';
    final linksJson = json['links'] as Map<String, dynamic>?;

    return MadeInDeveloper(
      githubUserName: json['githubUserName'] as String,
      name: json['name'] as String?,
      localAvatarPath: toLocalImagePath(rawAvatar),
      description: json['description'] as String?,
      links:
          linksJson != null ? MadeInDeveloperLinks.fromJson(linksJson) : null,
      projects: ((json['projects'] as List<dynamic>?) ?? [])
          .map((e) => MadeInAppRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
```

- [ ] **Step 6: Run model tests to confirm they pass**

```bash
dart test test/data/models/made_in_models_test.dart
```

Expected: All tests pass.

- [ ] **Step 7: Commit**

```bash
git add lib/data/models/made_in_flutter_belgium/ lib/util/made_in_utils.dart test/data/models/made_in_models_test.dart
git commit -m "feat: add Made in Flutter Belgium data models"
```

---

## Task 3: Repository Interface and Mock

**Files:**
- Create: `lib/data/repositories/made_in_flutter_belgium_repository.dart`
- Create: `lib/data/repositories/mock_made_in_flutter_belgium_repository.dart`
- Create: `test/data/repositories/mock_made_in_repository_test.dart`

- [ ] **Step 1: Write the failing mock repository tests**

Create `test/data/repositories/mock_made_in_repository_test.dart`:

```dart
import 'package:flutter_belgium_website/data/repositories/mock_made_in_flutter_belgium_repository.dart';
import 'package:test/test.dart';

void main() {
  late MockMadeInFlutterBelgiumRepository repo;
  setUp(() => repo = MockMadeInFlutterBelgiumRepository());

  test('getApps returns 3 apps with non-empty name and localIconPath', () async {
    final apps = await repo.getApps();
    expect(apps, hasLength(3));
    for (final app in apps) {
      expect(app.name, isNotEmpty);
      expect(app.localIconPath, isNotEmpty);
      expect(app.releaseDate, isA<DateTime>());
    }
  });

  test('getCompanies returns 3 companies with non-empty name and localLogoPath',
      () async {
    final companies = await repo.getCompanies();
    expect(companies, hasLength(3));
    for (final c in companies) {
      expect(c.name, isNotEmpty);
      expect(c.localLogoPath, isNotEmpty);
    }
  });

  test('getDevelopers returns 3 developers with githubUserName and localAvatarPath',
      () async {
    final devs = await repo.getDevelopers();
    expect(devs, hasLength(3));
    for (final d in devs) {
      expect(d.githubUserName, isNotEmpty);
      expect(d.localAvatarPath, isNotEmpty);
    }
  });
}
```

- [ ] **Step 2: Run tests to confirm they fail**

```bash
dart test test/data/repositories/mock_made_in_repository_test.dart
```

Expected: compile error.

- [ ] **Step 3: Create the repository interface**

`lib/data/repositories/made_in_flutter_belgium_repository.dart`:
```dart
import '../models/made_in_flutter_belgium/made_in_app.dart';
import '../models/made_in_flutter_belgium/made_in_company.dart';
import '../models/made_in_flutter_belgium/made_in_developer.dart';

abstract class MadeInFlutterBelgiumRepository {
  Future<List<MadeInApp>> getApps();
  Future<List<MadeInCompany>> getCompanies();
  Future<List<MadeInDeveloper>> getDevelopers();
}
```

- [ ] **Step 4: Create the mock repository**

`lib/data/repositories/mock_made_in_flutter_belgium_repository.dart`:
```dart
import '../models/made_in_flutter_belgium/made_in_app.dart';
import '../models/made_in_flutter_belgium/made_in_app_links.dart';
import '../models/made_in_flutter_belgium/made_in_company.dart';
import '../models/made_in_flutter_belgium/made_in_company_links.dart';
import '../models/made_in_flutter_belgium/made_in_developer.dart';
import '../models/made_in_flutter_belgium/made_in_developer_links.dart';
import 'made_in_flutter_belgium_repository.dart';

class MockMadeInFlutterBelgiumRepository
    implements MadeInFlutterBelgiumRepository {
  static final List<MadeInApp> _apps = [
    MadeInApp(
      name: 'Sample App One',
      localIconPath:
          'assets/made_in/projects/Sample App One/app_icon.webp',
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
      localIconPath:
          'assets/made_in/projects/Sample App Two/app_icon.webp',
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
      localIconPath:
          'assets/made_in/projects/Sample App Three/app_icon.webp',
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
```

- [ ] **Step 5: Run tests to confirm they pass**

```bash
dart test test/data/repositories/mock_made_in_repository_test.dart
```

Expected: All tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/data/repositories/made_in_flutter_belgium_repository.dart \
        lib/data/repositories/mock_made_in_flutter_belgium_repository.dart \
        test/data/repositories/mock_made_in_repository_test.dart
git commit -m "feat: add MadeInFlutterBelgiumRepository interface and mock"
```

---

## Task 4: HTTP Repository

**Files:**
- Create: `lib/data/repositories/http_made_in_flutter_belgium_repository.dart`

No unit test for HTTP calls (they are integration-level). The image URL logic is already covered by Task 1 tests.

- [ ] **Step 1: Create `lib/data/repositories/http_made_in_flutter_belgium_repository.dart`**

```dart
import 'dart:convert';
import 'dart:io';

import '../models/made_in_flutter_belgium/made_in_app.dart';
import '../models/made_in_flutter_belgium/made_in_company.dart';
import '../models/made_in_flutter_belgium/made_in_developer.dart';
import 'made_in_flutter_belgium_repository.dart';

class HttpMadeInFlutterBelgiumRepository
    implements MadeInFlutterBelgiumRepository {
  static const _base = 'https://api.madein.flutterbelgium.be';

  Future<dynamic> _get(String url) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      final body = await response.transform(const Utf8Decoder()).join();
      return json.decode(body);
    } finally {
      client.close();
    }
  }

  @override
  Future<List<MadeInApp>> getApps() async {
    final list =
        await _get('$_base/projects/minimized_all.json') as List<dynamic>;
    final names =
        list.map((e) => (e as Map<String, dynamic>)['name'] as String).toList();
    return Future.wait(names.map(_fetchApp));
  }

  Future<MadeInApp> _fetchApp(String name) async {
    final encoded = Uri.encodeComponent(name);
    final data =
        await _get('$_base/projects/$encoded/info.json') as Map<String, dynamic>;
    return MadeInApp.fromJson(data);
  }

  @override
  Future<List<MadeInCompany>> getCompanies() async {
    final list =
        await _get('$_base/companies/minimized_all.json') as List<dynamic>;
    final names =
        list.map((e) => (e as Map<String, dynamic>)['name'] as String).toList();
    return Future.wait(names.map(_fetchCompany));
  }

  Future<MadeInCompany> _fetchCompany(String name) async {
    final encoded = Uri.encodeComponent(name);
    final data = await _get('$_base/companies/$encoded/info.json')
        as Map<String, dynamic>;
    return MadeInCompany.fromJson(data);
  }

  @override
  Future<List<MadeInDeveloper>> getDevelopers() async {
    final list =
        await _get('$_base/developers/minimized_all.json') as List<dynamic>;
    final usernames = list
        .map((e) => (e as Map<String, dynamic>)['githubUserName'] as String)
        .toList();
    return Future.wait(usernames.map(_fetchDeveloper));
  }

  Future<MadeInDeveloper> _fetchDeveloper(String username) async {
    final data = await _get('$_base/developers/$username/info.json')
        as Map<String, dynamic>;
    return MadeInDeveloper.fromJson(data);
  }
}
```

- [ ] **Step 2: Verify it compiles and all existing tests still pass**

```bash
dart analyze lib/data/repositories/http_made_in_flutter_belgium_repository.dart
dart test
```

Expected: No analysis errors, all tests pass.

- [ ] **Step 3: Commit**

```bash
git add lib/data/repositories/http_made_in_flutter_belgium_repository.dart
git commit -m "feat: add HttpMadeInFlutterBelgiumRepository"
```

---

## Task 5: CSS Styles

**Files:**
- Modify: `web/styles.css`

- [ ] **Step 1: Append made-in styles to `web/styles.css`**

Open `web/styles.css` and append at the end:

```css
/* ── Made in Flutter Belgium ───────────────────────────────────── */
.made-in-hero { background: var(--color-navy); color: var(--color-white); padding: 4rem 1.5rem 0; }
.made-in-hero-inner { max-width: var(--container-max); margin: 0 auto; }
.made-in-hero .section-label { color: var(--color-yellow); }
.made-in-hero .section-title { color: var(--color-white); }

.made-in-tabs { display: flex; gap: 0.5rem; padding: 2rem 0 0; }
.made-in-tab { padding: 0.5rem 1.25rem; border-radius: 999px; font-size: 0.9rem; font-weight: 600; color: rgba(255,255,255,0.6); background: rgba(255,255,255,0.08); text-decoration: none; transition: background 0.2s, color 0.2s; }
.made-in-tab:hover { background: rgba(255,255,255,0.15); color: var(--color-white); }
.made-in-tab.active { background: var(--color-yellow); color: var(--color-navy); }

.made-in-content { background: var(--color-white); padding: var(--section-padding); }
.made-in-content-inner { max-width: var(--container-max); margin: 0 auto; }

.made-in-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 1.5rem; margin-top: 2rem; }

.made-in-card { display: flex; flex-direction: column; align-items: center; gap: 0.5rem; text-decoration: none; color: var(--color-navy); transition: transform 0.15s; }
.made-in-card:hover { transform: translateY(-3px); }
.made-in-card-img { width: 72px; height: 72px; border-radius: 16px; object-fit: cover; background: var(--color-grey); }
.made-in-card-name { font-size: 0.75rem; font-weight: 600; text-align: center; line-height: 1.3; max-width: 88px; overflow: hidden; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; }

/* Detail pages */
.made-in-detail { background: var(--color-white); padding: var(--section-padding); }
.made-in-detail-inner { max-width: 800px; margin: 0 auto; }
.made-in-detail-header { display: flex; align-items: flex-start; gap: 1.5rem; margin-bottom: 2rem; flex-wrap: wrap; }
.made-in-detail-icon { width: 96px; height: 96px; border-radius: 20px; object-fit: cover; flex-shrink: 0; }
.made-in-detail-logo { max-height: 64px; max-width: 200px; object-fit: contain; flex-shrink: 0; }
.made-in-detail-avatar { width: 96px; height: 96px; border-radius: 50%; object-fit: cover; flex-shrink: 0; }
.made-in-detail-meta { flex: 1; }
.made-in-detail-title { font-size: clamp(1.5rem, 3vw, 2rem); font-weight: 700; margin-bottom: 0.25rem; }
.made-in-detail-subtitle { font-size: 0.95rem; opacity: 0.6; margin-bottom: 0.5rem; }
.made-in-detail-sunset { background: var(--color-red); color: var(--color-white); padding: 0.75rem 1.25rem; border-radius: 8px; font-size: 0.9rem; margin-bottom: 1.5rem; }
.made-in-detail-description { font-size: 1.05rem; line-height: 1.75; opacity: 0.85; margin-bottom: 2rem; white-space: pre-line; }
.made-in-detail-links { display: flex; flex-wrap: wrap; gap: 0.75rem; margin-bottom: 2rem; }
.made-in-detail-link { padding: 0.5rem 1.25rem; border-radius: 999px; font-size: 0.875rem; font-weight: 600; background: var(--color-navy); color: var(--color-white); text-decoration: none; transition: opacity 0.2s; }
.made-in-detail-link:hover { opacity: 0.8; }
.made-in-detail-section-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 1rem; margin-top: 2rem; }
.made-in-screenshots { display: flex; gap: 1rem; overflow-x: auto; padding-bottom: 0.5rem; margin-bottom: 2rem; }
.made-in-screenshot { height: 320px; border-radius: 12px; flex-shrink: 0; }
.made-in-ref-grid { display: flex; flex-wrap: wrap; gap: 1rem; }

/* Home page showcase */
.showcase { background: var(--color-grey); padding: var(--section-padding); }
.showcase-inner { max-width: var(--container-max); margin: 0 auto; }
.showcase-apps { display: flex; gap: 1.5rem; flex-wrap: wrap; margin: 2rem 0; }
.showcase-cta { margin-top: 0.5rem; }

/* Badges */
.badge { display: inline-block; padding: 0.2rem 0.6rem; border-radius: 999px; font-size: 0.75rem; font-weight: 700; background: var(--color-sky); color: var(--color-white); margin-left: 0.5rem; vertical-align: middle; }
```

- [ ] **Step 2: Verify formatting and no analysis errors**

```bash
dart analyze
```

Expected: No errors (CSS changes don't affect Dart analysis).

- [ ] **Step 3: Commit**

```bash
git add web/styles.css
git commit -m "feat: add Made in Flutter Belgium CSS styles"
```

---

## Task 6: MadeInCard and MadeInPageShell Components

**Files:**
- Create: `lib/components/made_in_flutter_belgium/made_in_card.dart`
- Create: `lib/components/made_in_flutter_belgium/made_in_page_shell.dart`
- Create: `test/components/made_in_card_test.dart`
- Create: `test/components/made_in_page_shell_test.dart`

- [ ] **Step 1: Write the failing component tests**

`test/components/made_in_card_test.dart`:
```dart
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_card.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  testComponents('MadeInCard renders image and name, links to href',
      (tester) async {
    tester.pumpComponent(const MadeInCard(
      name: 'Bevoy',
      localImagePath: 'assets/made_in/projects/Bevoy/app_icon.webp',
      href: '/made-in-flutter-belgium/apps/bevoy',
    ));
    expect(find.tag('a'), findsOneComponent);
    expect(find.tag('img'), findsOneComponent);
    expect(find.text('Bevoy'), findsOneComponent);
  });
}
```

`test/components/made_in_page_shell_test.dart`:
```dart
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_page_shell.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  testComponents('MadeInPageShell renders hero title and all three tabs',
      (tester) async {
    tester.pumpComponent(const MadeInPageShell(
      activeTab: MadeInTab.apps,
      child: [],
    ));
    expect(find.text('Made in Flutter Belgium'), findsOneComponent);
    expect(find.text('apps'), findsOneComponent);
    expect(find.text('companies'), findsOneComponent);
    expect(find.text('developers'), findsOneComponent);
  });

  testComponents('MadeInPageShell marks the active tab with active class',
      (tester) async {
    tester.pumpComponent(const MadeInPageShell(
      activeTab: MadeInTab.companies,
      child: [],
    ));
    final activeTab = find.classes('made-in-tab active');
    expect(activeTab, findsOneComponent);
  });
}
```

- [ ] **Step 2: Run tests to confirm they fail**

```bash
dart test test/components/made_in_card_test.dart test/components/made_in_page_shell_test.dart
```

Expected: compile error.

- [ ] **Step 3: Create `MadeInCard`**

`lib/components/made_in_flutter_belgium/made_in_card.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

class MadeInCard extends StatelessComponent {
  const MadeInCard({
    required this.name,
    required this.localImagePath,
    required this.href,
    super.key,
  });

  final String name;
  final String localImagePath;
  final String href;

  @override
  Component build(BuildContext context) {
    return a(
      [
        img(
          src: '/$localImagePath',
          alt: name,
          classes: 'made-in-card-img',
        ),
        span(classes: 'made-in-card-name', [Component.text(name)]),
      ],
      href: href,
      classes: 'made-in-card',
    );
  }
}
```

- [ ] **Step 4: Create `MadeInPageShell`**

`lib/components/made_in_flutter_belgium/made_in_page_shell.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

enum MadeInTab { apps, companies, developers }

class MadeInPageShell extends StatelessComponent {
  const MadeInPageShell({
    required this.activeTab,
    required this.child,
    super.key,
  });

  final MadeInTab activeTab;
  final List<Component> child;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      section(classes: 'made-in-hero', [
        div(classes: 'made-in-hero-inner', [
          p(classes: 'section-label',
              [const Component.text('Flutter · Belgium')]),
          h1(classes: 'section-title',
              [const Component.text('Made in Flutter Belgium')]),
          p(classes: 'section-body', [
            const Component.text(
                'Apps, companies and developers from Belgium building with Flutter.'),
          ]),
          nav(classes: 'made-in-tabs', [
            _tab('apps', '/made-in-flutter-belgium/apps',
                activeTab == MadeInTab.apps),
            _tab('companies', '/made-in-flutter-belgium/companies',
                activeTab == MadeInTab.companies),
            _tab('developers', '/made-in-flutter-belgium/developers',
                activeTab == MadeInTab.developers),
          ]),
        ]),
      ]),
      section(classes: 'made-in-content', [
        div(classes: 'made-in-content-inner', child),
      ]),
    ]);
  }

  Component _tab(String label, String href, bool isActive) {
    return a(
      [Component.text(label)],
      href: href,
      classes: isActive ? 'made-in-tab active' : 'made-in-tab',
    );
  }
}
```

- [ ] **Step 5: Run component tests to confirm they pass**

```bash
dart test test/components/made_in_card_test.dart test/components/made_in_page_shell_test.dart
```

Expected: All tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/components/made_in_flutter_belgium/ \
        test/components/made_in_card_test.dart \
        test/components/made_in_page_shell_test.dart
git commit -m "feat: add MadeInCard and MadeInPageShell components"
```

---

## Task 7: List Pages

**Files:**
- Create: `lib/pages/made_in_flutter_belgium/made_in_apps_page.dart`
- Create: `lib/pages/made_in_flutter_belgium/made_in_companies_page.dart`
- Create: `lib/pages/made_in_flutter_belgium/made_in_developers_page.dart`

No separate tests — the shell and card are already tested; pages compose them.

- [ ] **Step 1: Create `MadeInAppsPage`**

`lib/pages/made_in_flutter_belgium/made_in_apps_page.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../../components/footer.dart';
import '../../components/made_in_flutter_belgium/made_in_card.dart';
import '../../components/made_in_flutter_belgium/made_in_page_shell.dart';
import '../../components/nav_bar.dart';
import '../../data/models/community_links.dart';
import '../../data/models/made_in_flutter_belgium/made_in_app.dart';
import '../../util/made_in_utils.dart';

class MadeInAppsPage extends StatelessComponent {
  const MadeInAppsPage({
    required this.apps,
    required this.communityLinks,
    super.key,
  });

  final List<MadeInApp> apps;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      MadeInPageShell(
        activeTab: MadeInTab.apps,
        child: [
          div(classes: 'made-in-grid', [
            for (final app in apps)
              MadeInCard(
                name: app.name,
                localImagePath: app.localIconPath,
                href: '/made-in-flutter-belgium/apps/${toSlug(app.name)}',
              ),
          ]),
        ],
      ),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
```

- [ ] **Step 2: Create `MadeInCompaniesPage`**

`lib/pages/made_in_flutter_belgium/made_in_companies_page.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../../components/footer.dart';
import '../../components/made_in_flutter_belgium/made_in_card.dart';
import '../../components/made_in_flutter_belgium/made_in_page_shell.dart';
import '../../components/nav_bar.dart';
import '../../data/models/community_links.dart';
import '../../data/models/made_in_flutter_belgium/made_in_company.dart';
import '../../util/made_in_utils.dart';

class MadeInCompaniesPage extends StatelessComponent {
  const MadeInCompaniesPage({
    required this.companies,
    required this.communityLinks,
    super.key,
  });

  final List<MadeInCompany> companies;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      MadeInPageShell(
        activeTab: MadeInTab.companies,
        child: [
          div(classes: 'made-in-grid', [
            for (final company in companies)
              MadeInCard(
                name: company.name,
                localImagePath: company.localLogoPath,
                href:
                    '/made-in-flutter-belgium/companies/${toSlug(company.name)}',
              ),
          ]),
        ],
      ),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
```

- [ ] **Step 3: Create `MadeInDevelopersPage`**

`lib/pages/made_in_flutter_belgium/made_in_developers_page.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../../components/footer.dart';
import '../../components/made_in_flutter_belgium/made_in_card.dart';
import '../../components/made_in_flutter_belgium/made_in_page_shell.dart';
import '../../components/nav_bar.dart';
import '../../data/models/community_links.dart';
import '../../data/models/made_in_flutter_belgium/made_in_developer.dart';
import '../../util/made_in_utils.dart';

class MadeInDevelopersPage extends StatelessComponent {
  const MadeInDevelopersPage({
    required this.developers,
    required this.communityLinks,
    super.key,
  });

  final List<MadeInDeveloper> developers;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      MadeInPageShell(
        activeTab: MadeInTab.developers,
        child: [
          div(classes: 'made-in-grid', [
            for (final dev in developers)
              MadeInCard(
                name: dev.name ?? dev.githubUserName,
                localImagePath: dev.localAvatarPath,
                href:
                    '/made-in-flutter-belgium/developers/${toSlug(dev.githubUserName)}',
              ),
          ]),
        ],
      ),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
```

- [ ] **Step 4: Verify compilation**

```bash
dart analyze lib/pages/made_in_flutter_belgium/
```

Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add lib/pages/made_in_flutter_belgium/made_in_apps_page.dart \
        lib/pages/made_in_flutter_belgium/made_in_companies_page.dart \
        lib/pages/made_in_flutter_belgium/made_in_developers_page.dart
git commit -m "feat: add Made in Flutter Belgium list pages"
```

---

## Task 8: App Detail Page

**Files:**
- Create: `lib/pages/made_in_flutter_belgium/made_in_app_detail_page.dart`

- [ ] **Step 1: Create `MadeInAppDetailPage`**

`lib/pages/made_in_flutter_belgium/made_in_app_detail_page.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../../components/footer.dart';
import '../../components/made_in_flutter_belgium/made_in_card.dart';
import '../../components/nav_bar.dart';
import '../../data/models/community_links.dart';
import '../../data/models/made_in_flutter_belgium/made_in_app.dart';
import '../../util/made_in_utils.dart';

class MadeInAppDetailPage extends StatelessComponent {
  const MadeInAppDetailPage({
    required this.app,
    required this.communityLinks,
    super.key,
  });

  final MadeInApp app;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'made-in-hero', [
        div(classes: 'made-in-hero-inner', [
          p(classes: 'section-label', [const Component.text('Made in Flutter Belgium · apps')]),
        ]),
      ]),
      section(classes: 'made-in-detail', [
        div(classes: 'made-in-detail-inner', [
          div(classes: 'made-in-detail-header', [
            img(
              src: '/${app.localIconPath}',
              alt: app.name,
              classes: 'made-in-detail-icon',
            ),
            div(classes: 'made-in-detail-meta', [
              h1(classes: 'made-in-detail-title', [Component.text(app.name)]),
              if (app.publisher != null)
                p(classes: 'made-in-detail-subtitle',
                    [Component.text(app.publisher!)]),
              p(classes: 'made-in-detail-subtitle', [
                Component.text(_formatDate(app.releaseDate)),
              ]),
            ]),
          ]),
          if (app.isSunsetted)
            div(classes: 'made-in-detail-sunset', [
              Component.text(
                  'This app has been sunset.${app.sunsetReason != null ? ' ${app.sunsetReason}' : ''}'),
            ]),
          p(classes: 'made-in-detail-description',
              [Component.text(app.description)]),
          _buildLinks(),
          if (app.screenshotPaths.isNotEmpty) ...[
            p(classes: 'made-in-detail-section-title',
                [const Component.text('Screenshots')]),
            div(classes: 'made-in-screenshots', [
              for (final path in app.screenshotPaths)
                img(src: '/$path', alt: 'Screenshot', classes: 'made-in-screenshot'),
            ]),
          ],
          if (app.involvedCompanies.isNotEmpty) ...[
            p(classes: 'made-in-detail-section-title',
                [const Component.text('Companies involved')]),
            div(classes: 'made-in-ref-grid', [
              for (final c in app.involvedCompanies)
                MadeInCard(
                  name: c.name,
                  localImagePath: c.localLogoPath,
                  href: '/made-in-flutter-belgium/companies/${toSlug(c.name)}',
                ),
            ]),
          ],
          if (app.developers.isNotEmpty) ...[
            p(classes: 'made-in-detail-section-title',
                [const Component.text('Developers')]),
            div(classes: 'made-in-ref-grid', [
              for (final d in app.developers)
                MadeInCard(
                  name: d.githubUserName,
                  localImagePath: d.localAvatarPath,
                  href:
                      '/made-in-flutter-belgium/developers/${toSlug(d.githubUserName)}',
                ),
            ]),
          ],
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }

  Component _buildLinks() {
    final links = <Component>[];
    final l = app.links;
    if (l.appstore != null)
      links.add(_link('App Store', l.appstore!));
    if (l.playstore != null)
      links.add(_link('Play Store', l.playstore!));
    if (l.webApp != null)
      links.add(_link('Web App', l.webApp!));
    if (l.marketingWebsite != null)
      links.add(_link('Website', l.marketingWebsite!));
    if (l.openSourceCode != null)
      links.add(_link('Open Source', l.openSourceCode!));
    if (l.youTube != null)
      links.add(_link('YouTube', l.youTube!));
    if (l.demoYouTubeVideo != null)
      links.add(_link('Demo Video', l.demoYouTubeVideo!));
    if (links.isEmpty) return Component.fragment([]);
    return div(classes: 'made-in-detail-links', links);
  }

  Component _link(String label, String url) => a(
        [Component.text(label)],
        href: url,
        classes: 'made-in-detail-link',
        attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
      );

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
```

- [ ] **Step 2: Verify compilation**

```bash
dart analyze lib/pages/made_in_flutter_belgium/made_in_app_detail_page.dart
```

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/pages/made_in_flutter_belgium/made_in_app_detail_page.dart
git commit -m "feat: add app detail page for Made in Flutter Belgium"
```

---

## Task 9: Company Detail Page

**Files:**
- Create: `lib/pages/made_in_flutter_belgium/made_in_company_detail_page.dart`

- [ ] **Step 1: Create `MadeInCompanyDetailPage`**

`lib/pages/made_in_flutter_belgium/made_in_company_detail_page.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../../components/footer.dart';
import '../../components/made_in_flutter_belgium/made_in_card.dart';
import '../../components/nav_bar.dart';
import '../../data/models/community_links.dart';
import '../../data/models/made_in_flutter_belgium/made_in_company.dart';
import '../../util/made_in_utils.dart';

class MadeInCompanyDetailPage extends StatelessComponent {
  const MadeInCompanyDetailPage({
    required this.company,
    required this.communityLinks,
    super.key,
  });

  final MadeInCompany company;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'made-in-hero', [
        div(classes: 'made-in-hero-inner', [
          p(classes: 'section-label',
              [const Component.text('Made in Flutter Belgium · companies')]),
        ]),
      ]),
      section(classes: 'made-in-detail', [
        div(classes: 'made-in-detail-inner', [
          div(classes: 'made-in-detail-header', [
            img(
              src: '/${company.localLogoPath}',
              alt: company.name,
              classes: 'made-in-detail-logo',
            ),
            div(classes: 'made-in-detail-meta', [
              h1(classes: 'made-in-detail-title', [
                Component.text(company.name),
                if (company.isAgency)
                  span(classes: 'badge', [const Component.text('Agency')]),
              ]),
            ]),
          ]),
          if (company.description != null)
            p(classes: 'made-in-detail-description',
                [Component.text(company.description!)]),
          if (company.links != null)
            div(classes: 'made-in-detail-links', [
              a(
                [const Component.text('Website')],
                href: company.links!.website,
                classes: 'made-in-detail-link',
                attributes: {'target': '_blank', 'rel': 'noopener noreferrer'},
              ),
              if (company.links!.jobWebsite != null)
                a(
                  [const Component.text('Jobs')],
                  href: company.links!.jobWebsite!,
                  classes: 'made-in-detail-link',
                  attributes: {
                    'target': '_blank',
                    'rel': 'noopener noreferrer'
                  },
                ),
            ]),
          if (company.projects.isNotEmpty) ...[
            p(classes: 'made-in-detail-section-title',
                [const Component.text('Projects')]),
            div(classes: 'made-in-ref-grid', [
              for (final p in company.projects)
                MadeInCard(
                  name: p.name,
                  localImagePath: p.localIconPath,
                  href: '/made-in-flutter-belgium/apps/${toSlug(p.name)}',
                ),
            ]),
          ],
          if (company.involvedProjects.isNotEmpty) ...[
            p(classes: 'made-in-detail-section-title',
                [const Component.text('Involved in')]),
            div(classes: 'made-in-ref-grid', [
              for (final p in company.involvedProjects)
                MadeInCard(
                  name: p.name,
                  localImagePath: p.localIconPath,
                  href: '/made-in-flutter-belgium/apps/${toSlug(p.name)}',
                ),
            ]),
          ],
          if (company.developers.isNotEmpty) ...[
            p(classes: 'made-in-detail-section-title',
                [const Component.text('Developers')]),
            div(classes: 'made-in-ref-grid', [
              for (final d in company.developers)
                MadeInCard(
                  name: d.githubUserName,
                  localImagePath: d.localAvatarPath,
                  href:
                      '/made-in-flutter-belgium/developers/${toSlug(d.githubUserName)}',
                ),
            ]),
          ],
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
```

- [ ] **Step 2: Verify compilation**

```bash
dart analyze lib/pages/made_in_flutter_belgium/made_in_company_detail_page.dart
```

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/pages/made_in_flutter_belgium/made_in_company_detail_page.dart
git commit -m "feat: add company detail page for Made in Flutter Belgium"
```

---

## Task 10: Developer Detail Page

**Files:**
- Create: `lib/pages/made_in_flutter_belgium/made_in_developer_detail_page.dart`

- [ ] **Step 1: Create `MadeInDeveloperDetailPage`**

`lib/pages/made_in_flutter_belgium/made_in_developer_detail_page.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../../components/footer.dart';
import '../../components/made_in_flutter_belgium/made_in_card.dart';
import '../../components/nav_bar.dart';
import '../../data/models/community_links.dart';
import '../../data/models/made_in_flutter_belgium/made_in_developer.dart';
import '../../util/made_in_utils.dart';

class MadeInDeveloperDetailPage extends StatelessComponent {
  const MadeInDeveloperDetailPage({
    required this.developer,
    required this.communityLinks,
    super.key,
  });

  final MadeInDeveloper developer;
  final CommunityLinks communityLinks;

  @override
  Component build(BuildContext context) {
    final displayName = developer.name ?? developer.githubUserName;

    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      section(classes: 'made-in-hero', [
        div(classes: 'made-in-hero-inner', [
          p(classes: 'section-label',
              [const Component.text('Made in Flutter Belgium · developers')]),
        ]),
      ]),
      section(classes: 'made-in-detail', [
        div(classes: 'made-in-detail-inner', [
          div(classes: 'made-in-detail-header', [
            img(
              src: '/${developer.localAvatarPath}',
              alt: displayName,
              classes: 'made-in-detail-avatar',
            ),
            div(classes: 'made-in-detail-meta', [
              h1(classes: 'made-in-detail-title', [Component.text(displayName)]),
              p(classes: 'made-in-detail-subtitle', [
                Component.text('@${developer.githubUserName}'),
              ]),
            ]),
          ]),
          if (developer.description != null)
            p(classes: 'made-in-detail-description',
                [Component.text(developer.description!)]),
          if (developer.links != null)
            div(classes: 'made-in-detail-links', [
              if (developer.links!.linkedin != null)
                a(
                  [const Component.text('LinkedIn')],
                  href: developer.links!.linkedin!,
                  classes: 'made-in-detail-link',
                  attributes: {
                    'target': '_blank',
                    'rel': 'noopener noreferrer'
                  },
                ),
              if (developer.links!.personalWebsite != null)
                a(
                  [const Component.text('Website')],
                  href: developer.links!.personalWebsite!,
                  classes: 'made-in-detail-link',
                  attributes: {
                    'target': '_blank',
                    'rel': 'noopener noreferrer'
                  },
                ),
              if (developer.links!.freelanceWebsite != null)
                a(
                  [const Component.text('Freelance')],
                  href: developer.links!.freelanceWebsite!,
                  classes: 'made-in-detail-link',
                  attributes: {
                    'target': '_blank',
                    'rel': 'noopener noreferrer'
                  },
                ),
            ]),
          if (developer.projects.isNotEmpty) ...[
            p(classes: 'made-in-detail-section-title',
                [const Component.text('Projects')]),
            div(classes: 'made-in-ref-grid', [
              for (final p in developer.projects)
                MadeInCard(
                  name: p.name,
                  localImagePath: p.localIconPath,
                  href: '/made-in-flutter-belgium/apps/${toSlug(p.name)}',
                ),
            ]),
          ],
        ]),
      ]),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
```

- [ ] **Step 2: Verify compilation**

```bash
dart analyze lib/pages/made_in_flutter_belgium/made_in_developer_detail_page.dart
```

Expected: No errors.

- [ ] **Step 3: Commit**

```bash
git add lib/pages/made_in_flutter_belgium/made_in_developer_detail_page.dart
git commit -m "feat: add developer detail page for Made in Flutter Belgium"
```

---

## Task 11: Home Page Showcase Section

**Files:**
- Create: `lib/components/made_in_flutter_belgium/made_in_showcase_section.dart`
- Create: `test/components/made_in_showcase_section_test.dart`

- [ ] **Step 1: Write the failing test**

`test/components/made_in_showcase_section_test.dart`:
```dart
import 'package:flutter_belgium_website/components/made_in_flutter_belgium/made_in_showcase_section.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app_links.dart';
import 'package:jaspr_test/jaspr_test.dart';

void main() {
  final apps = [
    MadeInApp(
      name: 'App One',
      localIconPath: 'assets/made_in/projects/App One/app_icon.webp',
      description: 'First app',
      releaseDate: DateTime(2025, 1, 1),
      isSunsetted: false,
      links: const MadeInAppLinks(),
      screenshotPaths: const [],
      developers: const [],
      involvedCompanies: const [],
    ),
    MadeInApp(
      name: 'App Two',
      localIconPath: 'assets/made_in/projects/App Two/app_icon.webp',
      description: 'Second app',
      releaseDate: DateTime(2025, 3, 1),
      isSunsetted: false,
      links: const MadeInAppLinks(),
      screenshotPaths: const [],
      developers: const [],
      involvedCompanies: const [],
    ),
  ];

  testComponents('MadeInShowcaseSection renders section label and CTA link',
      (tester) async {
    tester.pumpComponent(MadeInShowcaseSection(latestApps: apps));
    expect(find.tag('section'), findsOneComponent);
    expect(find.text('Explore what Belgians built with Flutter'),
        findsOneComponent);
  });

  testComponents('MadeInShowcaseSection renders a card per app', (tester) async {
    tester.pumpComponent(MadeInShowcaseSection(latestApps: apps));
    expect(find.text('App One'), findsOneComponent);
    expect(find.text('App Two'), findsOneComponent);
  });
}
```

- [ ] **Step 2: Run test to confirm it fails**

```bash
dart test test/components/made_in_showcase_section_test.dart
```

Expected: compile error.

- [ ] **Step 3: Create `MadeInShowcaseSection`**

`lib/components/made_in_flutter_belgium/made_in_showcase_section.dart`:
```dart
import 'package:jaspr/jaspr.dart';
import 'package:jaspr/dom.dart';

import '../../data/models/made_in_flutter_belgium/made_in_app.dart';
import '../../util/made_in_utils.dart';
import 'made_in_card.dart';

class MadeInShowcaseSection extends StatelessComponent {
  const MadeInShowcaseSection({required this.latestApps, super.key});

  final List<MadeInApp> latestApps;

  @override
  Component build(BuildContext context) {
    return section(classes: 'showcase', [
      div(classes: 'showcase-inner', [
        p(classes: 'section-label',
            [const Component.text('Made in Flutter Belgium')]),
        h2(classes: 'section-title',
            [const Component.text('Built with Flutter, made in Belgium')]),
        div(classes: 'showcase-apps', [
          for (final app in latestApps)
            MadeInCard(
              name: app.name,
              localImagePath: app.localIconPath,
              href: '/made-in-flutter-belgium/apps/${toSlug(app.name)}',
            ),
        ]),
        a(
          [const Component.text('Explore what Belgians built with Flutter')],
          href: '/made-in-flutter-belgium/apps',
          classes: 'btn btn-primary showcase-cta',
        ),
      ]),
    ]);
  }
}
```

- [ ] **Step 4: Run tests to confirm they pass**

```bash
dart test test/components/made_in_showcase_section_test.dart
```

Expected: All tests pass.

- [ ] **Step 5: Commit**

```bash
git add lib/components/made_in_flutter_belgium/made_in_showcase_section.dart \
        test/components/made_in_showcase_section_test.dart
git commit -m "feat: add Made in Flutter Belgium showcase section for home page"
```

---

## Task 12: Wire Up Routes, HomePage, and Footer

**Files:**
- Modify: `lib/main.server.dart`
- Modify: `lib/pages/home_page.dart`
- Modify: `lib/components/footer.dart`
- Modify: `lib/data/repositories/mock_flutter_belgium_repository.dart`

- [ ] **Step 1: Update `mock_flutter_belgium_repository.dart` — change madeInUrl to internal path**

In `lib/data/repositories/mock_flutter_belgium_repository.dart`, find:
```dart
madeInUrl: 'https://madein.flutterbelgium.be',
```

Replace with:
```dart
madeInUrl: '/made-in-flutter-belgium/apps',
```

- [ ] **Step 2: Update `footer.dart` — internal link (no target="_blank")**

In `lib/components/footer.dart`, find:
```dart
          a([const Component.text('Made in Flutter Belgium')],
              href: communityLinks.madeInUrl,
              classes: 'footer-social-link',
              attributes: {
                'target': '_blank',
                'rel': 'noopener noreferrer',
                'aria-label': 'Made in Flutter Belgium'
              }),
```

Replace with:
```dart
          a([const Component.text('Made in Flutter Belgium')],
              href: communityLinks.madeInUrl,
              classes: 'footer-social-link',
              attributes: {'aria-label': 'Made in Flutter Belgium'}),
```

- [ ] **Step 3: Update `home_page.dart` — add latestMadeInApps parameter and section**

Replace the entire content of `lib/pages/home_page.dart` with:

```dart
import 'package:jaspr/jaspr.dart';

import '../components/about_section.dart';
import '../components/footer.dart';
import '../components/hero_section.dart';
import '../components/hosting_companies_section.dart';
import '../components/join_section.dart';
import '../components/made_in_flutter_belgium/made_in_showcase_section.dart';
import '../components/nav_bar.dart';
import '../components/next_meetup_section.dart';
import '../components/past_meetups_section.dart';
import '../components/sponsor_section.dart';
import '../components/talks_section.dart';
import '../components/team_section.dart';
import '../components/testimonials_section.dart';
import '../data/models/community_links.dart';
import '../data/models/company.dart';
import '../data/models/made_in_flutter_belgium/made_in_app.dart';
import '../data/models/meetup.dart';
import '../data/models/sponsor.dart';
import '../data/models/talk.dart';
import '../data/models/team_member.dart';
import '../data/models/testimonial.dart';

class HomePage extends StatelessComponent {
  const HomePage({
    required this.nextMeetup,
    required this.pastMeetups,
    required this.talks,
    required this.communityLinks,
    required this.companies,
    required this.testimonials,
    required this.members,
    required this.sponsors,
    required this.latestMadeInApps,
    super.key,
  });

  final Meetup? nextMeetup;
  final List<Meetup> pastMeetups;
  final List<Talk> talks;
  final CommunityLinks communityLinks;
  final List<Company> companies;
  final List<Testimonial> testimonials;
  final List<TeamMember> members;
  final List<Sponsor> sponsors;
  final List<MadeInApp> latestMadeInApps;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      NavBar(communityLinks: communityLinks),
      HeroSection(communityLinks: communityLinks),
      const AboutSection(),
      TeamSection(members: members),
      MadeInShowcaseSection(latestApps: latestMadeInApps),
      NextMeetupSection(meetup: nextMeetup, communityLinks: communityLinks),
      HostingCompaniesSection(companies: companies),
      PastMeetupsSection(
          meetups: pastMeetups, meetupGroupUrl: communityLinks.meetupUrl),
      TalksSection(talks: talks),
      TestimonialsSection(testimonials: testimonials),
      JoinSection(communityLinks: communityLinks),
      SponsorSection(
          sponsors: sponsors, contactUrl: communityLinks.slackInviteUrl),
      Footer(communityLinks: communityLinks),
    ]);
  }
}
```

- [ ] **Step 4: Update `main.server.dart` — add made-in data fetching and routes**

Replace the entire content of `lib/main.server.dart` with:

```dart
import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'data/repositories/http_made_in_flutter_belgium_repository.dart';
import 'data/repositories/mock_flutter_belgium_repository.dart';
import 'main.server.options.dart';
import 'pages/branding_page.dart';
import 'pages/home_page.dart';
import 'pages/made_in_flutter_belgium/made_in_app_detail_page.dart';
import 'pages/made_in_flutter_belgium/made_in_apps_page.dart';
import 'pages/made_in_flutter_belgium/made_in_companies_page.dart';
import 'pages/made_in_flutter_belgium/made_in_company_detail_page.dart';
import 'pages/made_in_flutter_belgium/made_in_developer_detail_page.dart';
import 'pages/made_in_flutter_belgium/made_in_developers_page.dart';
import 'pages/privacy_policy_page.dart';
import 'pages/terms_page.dart';
import 'util/made_in_utils.dart';

void main() async {
  Jaspr.initializeApp(options: defaultServerOptions);

  final repository = MockFlutterBelgiumRepository();
  final madeInRepository = HttpMadeInFlutterBelgiumRepository();

  final nextMeetup = await repository.getNextMeetup();
  final pastMeetups = await repository.getPastMeetups();
  final talks = await repository.getAllTalks();
  final communityLinks = await repository.getCommunityLinks();
  final companies = await repository.getHostingCompanies();
  final testimonials = await repository.getTestimonials();
  final teamMembers = await repository.getTeamMembers();
  final sponsors = await repository.getSponsors();

  final madeInApps = await madeInRepository.getApps();
  final madeInCompanies = await madeInRepository.getCompanies();
  final madeInDevelopers = await madeInRepository.getDevelopers();

  final latestApps = ([...madeInApps]
        ..sort((a, b) => b.releaseDate.compareTo(a.releaseDate)))
      .take(5)
      .toList();

  runApp(Document(
    title: 'Flutter Belgium',
    lang: 'en',
    meta: {
      'description':
          'Flutter Belgium: the Belgian Flutter community. Meetups, talks, and a Slack community for Flutter developers in Belgium.',
    },
    head: [
      link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      link(
          rel: 'preconnect',
          href: 'https://fonts.gstatic.com',
          attributes: {'crossorigin': ''}),
      link(
        rel: 'stylesheet',
        href:
            'https://fonts.googleapis.com/css2?family=Google+Sans+Flex:ital,opsz,wght@0,12..72,100..900;1,12..72,100..900&display=swap',
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
          latestMadeInApps: latestApps,
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
        builder: (context, state) => TermsPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/branding',
        title: 'Branding | Flutter Belgium',
        builder: (context, state) =>
            BrandingPage(communityLinks: communityLinks),
      ),
      Route(
        path: '/made-in-flutter-belgium/apps',
        title: 'Apps | Made in Flutter Belgium',
        builder: (context, state) => MadeInAppsPage(
          apps: madeInApps,
          communityLinks: communityLinks,
        ),
      ),
      Route(
        path: '/made-in-flutter-belgium/companies',
        title: 'Companies | Made in Flutter Belgium',
        builder: (context, state) => MadeInCompaniesPage(
          companies: madeInCompanies,
          communityLinks: communityLinks,
        ),
      ),
      Route(
        path: '/made-in-flutter-belgium/developers',
        title: 'Developers | Made in Flutter Belgium',
        builder: (context, state) => MadeInDevelopersPage(
          developers: madeInDevelopers,
          communityLinks: communityLinks,
        ),
      ),
      for (final app in madeInApps)
        Route(
          path: '/made-in-flutter-belgium/apps/${toSlug(app.name)}',
          title: '${app.name} | Made in Flutter Belgium',
          builder: (context, state) => MadeInAppDetailPage(
            app: app,
            communityLinks: communityLinks,
          ),
        ),
      for (final company in madeInCompanies)
        Route(
          path: '/made-in-flutter-belgium/companies/${toSlug(company.name)}',
          title: '${company.name} | Made in Flutter Belgium',
          builder: (context, state) => MadeInCompanyDetailPage(
            company: company,
            communityLinks: communityLinks,
          ),
        ),
      for (final developer in madeInDevelopers)
        Route(
          path:
              '/made-in-flutter-belgium/developers/${toSlug(developer.githubUserName)}',
          title:
              '${developer.name ?? developer.githubUserName} | Made in Flutter Belgium',
          builder: (context, state) => MadeInDeveloperDetailPage(
            developer: developer,
            communityLinks: communityLinks,
          ),
        ),
    ]),
  ));
}
```

- [ ] **Step 5: Run full test suite and analysis**

```bash
dart analyze
dart test
```

Expected: No analysis errors, all tests pass.

- [ ] **Step 6: Commit**

```bash
git add lib/main.server.dart lib/pages/home_page.dart \
        lib/components/footer.dart \
        lib/data/repositories/mock_flutter_belgium_repository.dart
git commit -m "feat: wire up Made in Flutter Belgium routes and home page showcase"
```

---

## Task 13: CI Image Download Script and Deploy Update

**Files:**
- Create: `.github/workflows/scripts/download_made_in_images.py`
- Modify: `.github/workflows/deploy.yml`
- Modify: `.gitignore`

- [ ] **Step 1: Add `web/assets/made_in/` to `.gitignore`**

Open `.gitignore` and add after the existing entries:

```
# Made in Flutter Belgium (populated by CI, not committed)
web/assets/made_in/
```

- [ ] **Step 2: Create `.github/workflows/scripts/download_made_in_images.py`**

```python
#!/usr/bin/env python3
"""Downloads all Made in Flutter Belgium images before the Jaspr static build."""

import json
import os
import urllib.error
import urllib.request

BASE_URL = "https://api.madein.flutterbelgium.be"
ASSETS_DIR = "web/assets/made_in"


def fetch_json(url: str) -> object:
    encoded = url.replace(" ", "%20")
    with urllib.request.urlopen(encoded) as resp:
        return json.load(resp)


def download(url: str, local_path: str) -> None:
    os.makedirs(os.path.dirname(local_path), exist_ok=True)
    encoded = url.replace(" ", "%20")
    try:
        urllib.request.urlretrieve(encoded, local_path)
        print(f"  ✓ {local_path}")
    except urllib.error.URLError as exc:
        print(f"  ✗ {url}: {exc}")


def download_projects() -> None:
    print("Downloading project images...")
    projects = fetch_json(f"{BASE_URL}/projects/minimized_all.json")
    for project in projects:
        name = project["name"]
        info = fetch_json(f"{BASE_URL}/projects/{name}/info.json")
        images = info.get("images") or {}
        if icon := images.get("appIconUrl"):
            filename = icon.rsplit("/", 1)[-1]
            download(icon, f"{ASSETS_DIR}/projects/{name}/{filename}")
        if banner := images.get("bannerUrl"):
            filename = banner.rsplit("/", 1)[-1]
            download(banner, f"{ASSETS_DIR}/projects/{name}/{filename}")
        for screenshot in images.get("screenshotUrls") or []:
            filename = screenshot.rsplit("/", 1)[-1]
            download(screenshot, f"{ASSETS_DIR}/projects/{name}/{filename}")


def download_companies() -> None:
    print("Downloading company images...")
    companies = fetch_json(f"{BASE_URL}/companies/minimized_all.json")
    for company in companies:
        name = company["name"]
        info = fetch_json(f"{BASE_URL}/companies/{name}/info.json")
        images = info.get("images") or {}
        if logo := images.get("logoUrl"):
            filename = logo.rsplit("/", 1)[-1]
            download(logo, f"{ASSETS_DIR}/companies/{name}/{filename}")


def download_developers() -> None:
    print("Downloading developer avatars...")
    developers = fetch_json(f"{BASE_URL}/developers/minimized_all.json")
    for dev in developers:
        username = dev["githubUserName"]
        avatar_url = dev.get("profilePictureUrl", "")
        if avatar_url:
            download(avatar_url, f"{ASSETS_DIR}/developers/{username}/avatar.jpg")


if __name__ == "__main__":
    download_projects()
    download_companies()
    download_developers()
    print("Done.")
```

- [ ] **Step 3: Update `deploy.yml` — add image download step before jaspr build**

In `.github/workflows/deploy.yml`, find the `build-and-deploy` job steps and insert after "Install dependencies" and before "Build static site":

```yaml
      - name: Download Made in Flutter Belgium images
        run: python3 .github/workflows/scripts/download_made_in_images.py
```

The relevant section becomes:
```yaml
      - name: Install dependencies
        run: dart pub get

      - name: Download Made in Flutter Belgium images
        run: python3 .github/workflows/scripts/download_made_in_images.py

      - name: Build static site
        run: dart run jaspr_cli:jaspr build
```

- [ ] **Step 4: Verify script syntax**

```bash
python3 -m py_compile .github/workflows/scripts/download_made_in_images.py && echo "OK"
```

Expected: `OK`

- [ ] **Step 5: Run full test suite one final time**

```bash
dart analyze
dart test
dart format --output=none --set-exit-if-changed lib/ test/
```

Expected: No errors, no formatting issues, all tests pass.

- [ ] **Step 6: Commit**

```bash
git add .gitignore \
        .github/workflows/scripts/download_made_in_images.py \
        .github/workflows/deploy.yml
git commit -m "feat: add CI image download script for Made in Flutter Belgium"
```

---

## Self-Review Checklist

- [x] **Routes** — all 7 routes from spec implemented (redirect omitted in favour of direct links; `/made-in-flutter-belgium/apps` is the canonical entry point)
- [x] **Data models** — MadeInApp, MadeInCompany, MadeInDeveloper + all link/ref types, fromJson, image URL transformation
- [x] **Repository** — abstract interface, mock (3 entries each), HTTP (parallel fetches)
- [x] **Image handling** — CI Python script downloads all images; gitignore prevents committing them; Dart transformation maps API URLs to local paths
- [x] **List pages** — apps, companies, developers with MadeInPageShell + MadeInCard grid
- [x] **Detail pages** — app, company, developer with full data display
- [x] **Home page showcase** — MadeInShowcaseSection with 5 latest apps + CTA
- [x] **Footer** — madeInUrl changed to internal path, target="_blank" removed
- [x] **Tests** — utilities, models, mock repository, MadeInCard, MadeInPageShell, MadeInShowcaseSection
- [x] **Type consistency** — MadeInApp/Company/Developer used consistently across tasks; toSlug/toLocalImagePath imported from made_in_utils.dart throughout
