import 'package:flutter_belgium_website/util/made_in_utils.dart';

class MadeInCompanyRef {
  const MadeInCompanyRef({
    required this.name,
    required this.localLogoPath,
    required this.useLogoInsteadOfTextTitle,
  });

  final String name;
  final String localLogoPath;
  final bool useLogoInsteadOfTextTitle;

  factory MadeInCompanyRef.fromJson(Map<String, dynamic> json) =>
      MadeInCompanyRef(
        name: json['name'] as String,
        localLogoPath: toLocalImagePath(json['logoUrl'] as String? ?? ''),
        useLogoInsteadOfTextTitle:
            json['useLogoInsteadOfTextTitle'] as bool? ?? false,
      );
}
