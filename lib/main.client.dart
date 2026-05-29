import 'package:jaspr/client.dart';

import 'package:flutter_belgium_website/main.client.options.dart';

void main() {
  Jaspr.initializeApp(options: defaultClientOptions);
  runApp(const ClientApp());
}
