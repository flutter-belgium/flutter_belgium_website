class Testimonial {
  const Testimonial({
    required this.text,
    required this.authorName,
    required this.authorRole,
    this.authorAvatarUrl,
  });
  final String text;
  final String authorName;
  final String authorRole;
  final String? authorAvatarUrl;
}
