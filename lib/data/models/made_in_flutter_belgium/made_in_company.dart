import 'package:flutter_belgium_website/util/made_in_utils.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app_ref.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company_links.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_developer_ref.dart';

class MadeInCompany {
  const MadeInCompany({
    required this.name,
    required this.localLogoPath,
    required this.useLogoInsteadOfTextTitle,
    this.description,
    this.links,
    required this.isAgency,
    required this.developers,
    required this.projects,
    required this.involvedProjects,
  });

  final String name;
  final String localLogoPath;
  final bool useLogoInsteadOfTextTitle;
  final bool isAgency;
  final String? description;
  final MadeInCompanyLinks? links;
  final List<MadeInDeveloperRef> developers;
  final List<MadeInAppRef> projects;
  final List<MadeInAppRef> involvedProjects;

  factory MadeInCompany.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as Map?)?.cast<String, dynamic>() ?? {};
    final rawLogo = images['logoUrl'] as String? ?? '';
    final linksJson = (json['links'] as Map?)?.cast<String, dynamic>();
    return MadeInCompany(
      name: json['name'] as String,
      localLogoPath: toLocalImagePath(rawLogo),
      useLogoInsteadOfTextTitle:
          json['useLogoInsteadOfTextTitle'] as bool? ?? false,
      description: json['description'] as String?,
      links: linksJson != null ? MadeInCompanyLinks.fromJson(linksJson) : null,
      isAgency: json['isAgency'] as bool? ?? false,
      developers: ((json['developers'] as List<dynamic>?) ?? [])
          .map((e) => MadeInDeveloperRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: ((json['projects'] as List<dynamic>?) ?? [])
          .map((e) => MadeInAppRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      involvedProjects: ((json['involvedProjects'] as List<dynamic>?) ?? [])
          .map((e) => MadeInAppRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
