import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_developer.dart';

abstract class MadeInFlutterBelgiumRepository {
  Future<List<MadeInApp>> getApps();
  Future<List<MadeInCompany>> getCompanies();
  Future<List<MadeInDeveloper>> getDevelopers();
}
