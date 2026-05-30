import 'package:flutter_belgium_website/util/made_in_utils.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app_links.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company_ref.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_developer_ref.dart';

class MadeInApp {
  const MadeInApp({
    required this.name,
    required this.localIconPath,
    required this.description,
    this.publisher,
    required this.releaseDate,
    required this.isSunsetted,
    this.sunsetReason,
    required this.links,
    this.localBannerPath,
    required this.screenshotPaths,
    required this.developers,
    required this.involvedCompanies,
  });

  final String name;
  final String localIconPath;
  final String description;
  final String? publisher;
  final String? sunsetReason;
  final String? localBannerPath;
  final DateTime releaseDate;
  final bool isSunsetted;
  final MadeInAppLinks links;
  final List<String> screenshotPaths;
  final List<MadeInDeveloperRef> developers;
  final List<MadeInCompanyRef> involvedCompanies;

  factory MadeInApp.fromJson(Map<String, dynamic> json) {
    final images = (json['images'] as Map?)?.cast<String, dynamic>() ?? {};
    final rawIcon = images['appIconUrl'] as String? ?? '';
    final rawBanner = images['bannerUrl'] as String?;
    final rawScreenshots =
        (images['screenshotUrls'] as List<dynamic>?)?.cast<String>() ?? [];
    final linksJson = (json['links'] as Map?)?.cast<String, dynamic>() ?? {};
    return MadeInApp(
      name: json['name'] as String,
      localIconPath: toLocalImagePath(rawIcon),
      description: json['description'] as String? ?? '',
      publisher: json['publisher'] as String?,
      releaseDate: DateTime.parse(json['releaseData'] as String),
      isSunsetted: json['isSunsetted'] as bool? ?? false,
      sunsetReason: json['sunsetReason'] as String?,
      links: MadeInAppLinks.fromJson(linksJson),
      localBannerPath: rawBanner != null ? toLocalImagePath(rawBanner) : null,
      screenshotPaths: rawScreenshots.map(toLocalImagePath).toList(),
      developers: ((json['developers'] as List<dynamic>?) ?? [])
          .map((e) => MadeInDeveloperRef.fromJson(e as Map<String, dynamic>))
          .toList(),
      involvedCompanies: ((json['involvedCompanies'] as List<dynamic>?) ?? [])
          .map((e) => MadeInCompanyRef.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
