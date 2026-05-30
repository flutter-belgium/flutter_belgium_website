import 'package:flutter_belgium_website/data/models/person.dart';

class Talk {
  const Talk({
    required this.id,
    required this.title,
    required this.date,
    this.youtubeUrl,
    required this.speakers,
  });

  final String id;
  final String title;
  final DateTime date;
  final String? youtubeUrl;
  final List<Person> speakers;

  String? get thumbnailUrl {
    final videoId = Uri.tryParse(youtubeUrl ?? '')?.queryParameters['v'];
    if (videoId == null || videoId.isEmpty) return null;
    return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
  }
}
