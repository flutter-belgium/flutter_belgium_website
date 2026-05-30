import 'package:flutter_belgium_data/flutter_belgium_data.dart';

Future<void> main() async {
  await FlutterBelgiumData.tools.downloadMadeInAssets();
  print('Done.');
}
