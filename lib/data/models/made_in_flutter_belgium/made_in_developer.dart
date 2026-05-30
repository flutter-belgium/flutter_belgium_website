import 'package:flutter_belgium_website/util/made_in_utils.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app_ref.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_developer_links.dart';

class MadeInDeveloper {
  const MadeInDeveloper({
    required this.githubUserName,
    this.name,
    required this.localAvatarPath,
    this.description,
    this.links,
    required this.projects,
  });

  final String githubUserName;
  final String localAvatarPath;
  final String? name;
  final String? description;
  final MadeInDeveloperLinks? links;
  final List<MadeInAppRef> projects;

  factory MadeInDeveloper.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as Map?)?.cast<String, dynamic>() ?? {};
    final rawAvatar = images['profilePictureUrl'] as String? ?? '';
    final linksJson = (json['links'] as Map?)?.cast<String, dynamic>();
    return MadeInDeveloper(
      githubUserName: json['githubUserName'] as String,
      name: json['name'] as String?,
      localAvatarPath: toLocalImagePath(rawAvatar),
      description: json['description'] as String?,
      links:
          linksJson != null ? MadeInDeveloperLinks.fromJson(linksJson) : null,
      projects: ((json['projects'] as List<dynamic>?) ?? [])
          .map((e) => MadeInAppRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
