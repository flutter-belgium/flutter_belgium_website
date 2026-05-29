class Meetup {
  const Meetup(
      {required this.id,
      required this.title,
      required this.date,
      required this.hostCompany,
      required this.location,
      this.description,
      this.thumbnailUrl,
      this.meetupUrl});
  final String id;
  final String title;
  final DateTime date;
  final String hostCompany;
  final String location;
  final String? description;
  final String? thumbnailUrl;
  final String? meetupUrl;
}
