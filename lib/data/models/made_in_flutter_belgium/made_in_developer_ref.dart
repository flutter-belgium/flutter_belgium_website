import 'package:flutter_belgium_website/util/made_in_utils.dart';

class MadeInDeveloperRef {
  const MadeInDeveloperRef({
    required this.githubUserName,
    required this.localAvatarPath,
  });

  final String githubUserName;
  final String localAvatarPath;

  factory MadeInDeveloperRef.fromJson(Map<String, dynamic> json) =>
      MadeInDeveloperRef(
        githubUserName: json['githubUserName'] as String,
        localAvatarPath:
            toLocalImagePath(json['profilePictureUrl'] as String? ?? ''),
      );
}
