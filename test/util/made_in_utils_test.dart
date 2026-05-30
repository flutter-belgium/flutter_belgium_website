import 'package:flutter_belgium_data/flutter_belgium_data.dart';
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
        toLocalImagePath(
            'https://avatars.githubusercontent.com/vanlooverenkoen'),
        'assets/made_in/developers/vanlooverenkoen/avatar.jpg',
      );
    });

    test('strips query params from GitHub avatar URL', () {
      expect(
        toLocalImagePath(
            'https://avatars.githubusercontent.com/vanlooverenkoen?v=4'),
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
