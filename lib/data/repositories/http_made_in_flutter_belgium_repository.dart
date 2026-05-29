import 'dart:convert';
import 'dart:io';

import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_app.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_company.dart';
import 'package:flutter_belgium_website/data/models/made_in_flutter_belgium/made_in_developer.dart';
import 'package:flutter_belgium_website/data/repositories/made_in_flutter_belgium_repository.dart';

class HttpMadeInFlutterBelgiumRepository
    implements MadeInFlutterBelgiumRepository {
  static const _base = 'https://api.madein.flutterbelgium.be';

  Future<dynamic> _get(String url) async {
    final client = HttpClient();
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close();
      final body = await response.transform(const Utf8Decoder()).join();
      return json.decode(body);
    } finally {
      client.close();
    }
  }

  @override
  Future<List<MadeInApp>> getApps() async {
    final list =
        await _get('$_base/projects/minimized_all.json') as List<dynamic>;
    final names =
        list.map((e) => (e as Map<String, dynamic>)['name'] as String).toList();
    return Future.wait(names.map(_fetchApp));
  }

  Future<MadeInApp> _fetchApp(String name) async {
    final encoded = Uri.encodeComponent(name);
    final data = await _get('$_base/projects/$encoded/info.json')
        as Map<String, dynamic>;
    return MadeInApp.fromJson(data);
  }

  @override
  Future<List<MadeInCompany>> getCompanies() async {
    final list =
        await _get('$_base/companies/minimized_all.json') as List<dynamic>;
    final names =
        list.map((e) => (e as Map<String, dynamic>)['name'] as String).toList();
    return Future.wait(names.map(_fetchCompany));
  }

  Future<MadeInCompany> _fetchCompany(String name) async {
    final encoded = Uri.encodeComponent(name);
    final data = await _get('$_base/companies/$encoded/info.json')
        as Map<String, dynamic>;
    return MadeInCompany.fromJson(data);
  }

  @override
  Future<List<MadeInDeveloper>> getDevelopers() async {
    final list =
        await _get('$_base/developers/minimized_all.json') as List<dynamic>;
    final usernames = list
        .map((e) => (e as Map<String, dynamic>)['githubUserName'] as String)
        .toList();
    return Future.wait(usernames.map(_fetchDeveloper));
  }

  Future<MadeInDeveloper> _fetchDeveloper(String username) async {
    final data = await _get('$_base/developers/$username/info.json')
        as Map<String, dynamic>;
    return MadeInDeveloper.fromJson(data);
  }
}
