import 'package:flutter_belgium_website/data/models/talk.dart';
import 'package:flutter_belgium_website/util/string_utils.dart';

class Meetup {
  const Meetup({
    required this.id,
    required this.title,
    required this.date,
    required this.hostCompany,
    required this.location,
    this.talks = const [],
    this.description,
    this.thumbnailUrl,
    this.meetupUrl,
  });

  final String id;
  final String title;
  final DateTime date;
  final String hostCompany;
  final String location;
  final List<Talk> talks;
  final String? description;
  final String? thumbnailUrl;
  final String? meetupUrl;

  String get slug => toSlug(title);
}
