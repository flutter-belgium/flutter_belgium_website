class MadeInAppLinks {
  const MadeInAppLinks({
    this.appstore,
    this.playstore,
    this.webApp,
    this.marketingWebsite,
    this.youTube,
    this.demoYouTubeVideo,
    this.openSourceCode,
  });

  final String? appstore;
  final String? playstore;
  final String? webApp;
  final String? marketingWebsite;
  final String? youTube;
  final String? demoYouTubeVideo;
  final String? openSourceCode;

  factory MadeInAppLinks.fromJson(Map<String, dynamic> json) => MadeInAppLinks(
        appstore: json['appstore'] as String?,
        playstore: json['playstore'] as String?,
        webApp: json['webApp'] as String?,
        marketingWebsite: json['marketingWebsite'] as String?,
        youTube: json['youTube'] as String?,
        demoYouTubeVideo: json['demoYouTubeVideo'] as String?,
        openSourceCode: json['openSourceCode'] as String?,
      );
}
