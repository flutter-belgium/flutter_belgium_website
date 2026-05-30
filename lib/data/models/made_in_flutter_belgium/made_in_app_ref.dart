import 'package:flutter_belgium_website/util/made_in_utils.dart';

class MadeInAppRef {
  const MadeInAppRef({
    required this.name,
    required this.localIconPath,
  });

  final String name;
  final String localIconPath;

  factory MadeInAppRef.fromJson(Map<String, dynamic> json) => MadeInAppRef(
        name: json['name'] as String,
        localIconPath: toLocalImagePath(json['appIconUrl'] as String? ?? ''),
      );
}
