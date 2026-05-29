import 'dart:convert';
import 'dart:io';

const _base = 'https://api.madein.flutterbelgium.be';
const _assetsDir = 'web/assets/made_in';

Future<dynamic> _fetchJson(String url) async {
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

Future<void> _download(String url, String localPath) async {
  await Directory(localPath).parent.create(recursive: true);
  final client = HttpClient();
  try {
    final request = await client.getUrl(Uri.parse(url));
    final response = await request.close();
    await response.pipe(File(localPath).openWrite());
    print('  ✓ $localPath');
  } catch (e) {
    print('  ✗ $url: $e');
  } finally {
    client.close();
  }
}

String _filename(String url) => url.split('/').last;

Future<void> _downloadProjects() async {
  print('Downloading project images...');
  final projects =
      await _fetchJson('$_base/projects/minimized_all.json') as List<dynamic>;
  for (final project in projects) {
    final name = (project as Map<String, dynamic>)['name'] as String;
    final encoded = Uri.encodeComponent(name);
    final info = await _fetchJson('$_base/projects/$encoded/info.json')
        as Map<String, dynamic>;
    final images = (info['images'] as Map<String, dynamic>?) ?? {};
    final icon = images['appIconUrl'] as String?;
    final banner = images['bannerUrl'] as String?;
    final screenshots =
        (images['screenshotUrls'] as List<dynamic>?)?.cast<String>() ?? [];
    if (icon != null) {
      await _download(icon, '$_assetsDir/projects/$name/${_filename(icon)}');
    }
    if (banner != null) {
      await _download(
          banner, '$_assetsDir/projects/$name/${_filename(banner)}');
    }
    for (final screenshot in screenshots) {
      await _download(
          screenshot, '$_assetsDir/projects/$name/${_filename(screenshot)}');
    }
  }
}

Future<void> _downloadCompanies() async {
  print('Downloading company images...');
  final companies =
      await _fetchJson('$_base/companies/minimized_all.json') as List<dynamic>;
  for (final company in companies) {
    final name = (company as Map<String, dynamic>)['name'] as String;
    final encoded = Uri.encodeComponent(name);
    final info = await _fetchJson('$_base/companies/$encoded/info.json')
        as Map<String, dynamic>;
    final images = (info['images'] as Map<String, dynamic>?) ?? {};
    final logo = images['logoUrl'] as String?;
    if (logo != null) {
      await _download(logo, '$_assetsDir/companies/$name/${_filename(logo)}');
    }
  }
}

Future<void> _downloadDevelopers() async {
  print('Downloading developer avatars...');
  final developers =
      await _fetchJson('$_base/developers/minimized_all.json') as List<dynamic>;
  for (final dev in developers) {
    final username = (dev as Map<String, dynamic>)['githubUserName'] as String;
    final avatarUrl = dev['profilePictureUrl'] as String? ?? '';
    if (avatarUrl.isNotEmpty) {
      await _download(
          avatarUrl, '$_assetsDir/developers/$username/avatar.jpg');
    }
  }
}

Future<void> main() async {
  await _downloadProjects();
  await _downloadCompanies();
  await _downloadDevelopers();
  print('Done.');
}
