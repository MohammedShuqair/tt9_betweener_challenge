import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:tt9_betweener_challenge/controllers/api_settings.dart';
import 'package:tt9_betweener_challenge/controllers/shared_helper.dart';
import 'package:tt9_betweener_challenge/views/login_view.dart';

import '../features/profile/links/model/link.dart';
import 'package:http/http.dart' as http;

Future<List<Link>> getLinks(context) async {
  final response = await http.get(Uri.parse(ApiSettings.links),
      headers: {'Authorization': 'Bearer ${SharedHelper().getToken()}'});

  if (response.statusCode == 200) {
    print('Link data');
    print(jsonDecode(response.body));
    final data = jsonDecode(response.body)['links'] as List<dynamic>;

    return data.map((e) => Link.fromJson(e)).toList();
  }

  if (response.statusCode == 401) {
    Navigator.pushReplacementNamed(context, LoginView.id);
  }

  return Future.error('Somthing wrong');
}
