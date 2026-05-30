import 'package:flutter_belgium_website/data/models/person.dart';

class Testimonial {
  const Testimonial({
    required this.text,
    required this.author,
  });

  final String text;
  final Person author;
}
