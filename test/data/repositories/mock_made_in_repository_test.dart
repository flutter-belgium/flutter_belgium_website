import 'package:flutter_belgium_website/data/repositories/mock_made_in_flutter_belgium_repository.dart';
import 'package:test/test.dart';

void main() {
  late MockMadeInFlutterBelgiumRepository repo;
  setUp(() => repo = MockMadeInFlutterBelgiumRepository());

  test('getApps returns 3 apps with non-empty name and localIconPath',
      () async {
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

  test(
      'getDevelopers returns 3 developers with githubUserName and localAvatarPath',
      () async {
    final devs = await repo.getDevelopers();
    expect(devs, hasLength(3));
    for (final d in devs) {
      expect(d.githubUserName, isNotEmpty);
      expect(d.localAvatarPath, isNotEmpty);
    }
  });
}
