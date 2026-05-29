class Talk {
  const Talk({required this.youtubeUrl});

  final String youtubeUrl;

  String get thumbnailUrl {
    final videoId = Uri.tryParse(youtubeUrl)?.queryParameters['v'];
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
