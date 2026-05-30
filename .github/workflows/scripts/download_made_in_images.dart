import 'package:flutter_belgium_data/flutter_belgium_data.dart';

Future<void> main() async {
  await FlutterBelgiumData.tools.downloadMadeInAssets();
  print('Done downloading Made in Flutter Belgium images');
  await FlutterBelgiumData.tools.downloadFlutterBelgiumAssets(config: AirTableConfig.fromEnvironment());
  print('Done downloading Flutter Belgium assets');
}
