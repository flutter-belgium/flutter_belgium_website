class MadeInCompanyLinks {
  const MadeInCompanyLinks({
    required this.website,
    this.jobWebsite,
  });

  final String website;
  final String? jobWebsite;

  factory MadeInCompanyLinks.fromJson(Map<String, dynamic> json) =>
      MadeInCompanyLinks(
        website: json['website'] as String,
        jobWebsite: json['jobWebsite'] as String?,
      );
}
