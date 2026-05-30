class MadeInDeveloperLinks {
  const MadeInDeveloperLinks({
    this.linkedin,
    this.personalWebsite,
    this.freelanceWebsite,
  });

  final String? linkedin;
  final String? personalWebsite;
  final String? freelanceWebsite;

  factory MadeInDeveloperLinks.fromJson(Map<String, dynamic> json) =>
      MadeInDeveloperLinks(
        linkedin: json['linkedin'] as String?,
        personalWebsite: json['personalWebsite'] as String?,
        freelanceWebsite: json['freelanceWebsite'] as String?,
      );
}
