import 'speaker.dart';

class Talk {
  const Talk(
      {required this.id,
      required this.title,
      required this.speaker,
      required this.meetupId,
      required this.meetupTitle,
      this.youtubeUrl,
      this.thumbnailUrl});
  final String id;
  final String title;
  final Speaker speaker;
  final String meetupId;
  final String meetupTitle;
  final String? youtubeUrl;
  final String? thumbnailUrl;
}
