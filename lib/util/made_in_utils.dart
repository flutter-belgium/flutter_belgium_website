String toLocalImagePath(String url) {
  const apiBase = 'https://api.madein.flutterbelgium.be/';
  const githubBase = 'https://avatars.githubusercontent.com/';

  if (url.startsWith(apiBase)) {
    final path = url.substring(apiBase.length);
    return 'assets/made_in/${path.replaceFirst('/images/', '/')}';
  }
  if (url.startsWith(githubBase)) {
    final username = url.substring(githubBase.length).split('?').first;
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
