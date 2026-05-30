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
                'https://avatars.githubusercontent.com/tijlivens'
          }
        ],
        'links': {
          'appstore': 'https://apps.apple.com/be/app/bevoy/id6443584006',
          'playstore': null,
          'webApp': null,
          'marketingWebsite': 'https://bevoy.be',
          'youTube': null,
          'demoYouTubeVideo': null,
          'openSourceCode': null
        },
        'sunsetReason': null,
        'images': {
          'appIconUrl':
              'https://api.madein.flutterbelgium.be/projects/Bevoy/images/app_icon.webp',
          'screenshotUrls': [
            'https://api.madein.flutterbelgium.be/projects/Bevoy/images/screenshot_1.webp'
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
            'useLogoInsteadOfTextTitle': true
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
        'description': 'Built alone.',
        'releaseData': '2024-01-01T00:00:00.000',
        'isSunsetted': false,
        'links': {},
        'images': {
          'appIconUrl':
              'https://api.madein.flutterbelgium.be/projects/Solo App/images/app_icon.webp'
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
          'jobWebsite': 'https://jobs.icapps.com'
        },
        'developers': null,
        'projects': [],
        'involvedProjects': [
          {
            'name': 'Gaia',
            'appIconUrl':
                'https://api.madein.flutterbelgium.be/projects/Gaia/images/app_icon.webp'
          }
        ],
        'images': {
          'logoUrl':
              'https://api.madein.flutterbelgium.be/companies/icapps/images/logo.svg'
        },
        'isAgency': true,
      };
      final company = MadeInCompany.fromJson(json);
      expect(company.name, 'icapps');
      expect(company.useLogoInsteadOfTextTitle, true);
      expect(company.description, 'Full-service digital partner.');
      expect(company.localLogoPath, 'assets/made_in/companies/icapps/logo.svg');
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
              'https://avatars.githubusercontent.com/vanlooverenkoen'
        },
        'links': {
          'linkedin': 'https://linkedin.com/in/vanlooverenkoen/',
          'personalWebsite': 'https://vanlooverenkoen.be',
          'freelanceWebsite': null
        },
        'projects': [
          {
            'name': 'Gaia',
            'appIconUrl':
                'https://api.madein.flutterbelgium.be/projects/Gaia/images/app_icon.webp'
          }
        ],
      };
      final dev = MadeInDeveloper.fromJson(json);
      expect(dev.githubUserName, 'vanlooverenkoen');
      expect(dev.name, 'Koen Van Looveren');
      expect(dev.description, 'Flutter developer.');
      expect(dev.localAvatarPath,
          'assets/made_in/developers/vanlooverenkoen/avatar.jpg');
      expect(dev.links!.linkedin, 'https://linkedin.com/in/vanlooverenkoen/');
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
              'https://avatars.githubusercontent.com/aaltrarjen'
        },
      };
      final dev = MadeInDeveloper.fromJson(json);
      expect(dev.name, isNull);
      expect(dev.links, isNull);
      expect(dev.projects, isEmpty);
    });
  });
}
