import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tt9_betweener_challenge/controllers/shared_helper.dart';
import 'package:tt9_betweener_challenge/models/follow_data.dart';
import 'package:tt9_betweener_challenge/models/link.dart';
import 'package:tt9_betweener_challenge/models/sender.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:tt9_betweener_challenge/views/login_view.dart';
import 'package:tt9_betweener_challenge/views/widgets/alert.dart';

import 'api_settings.dart';

class ApiHelper {
  Map<String, String> headers = {
    'Authorization': 'Bearer ${SharedHelper().getToken()}',
    'Accept': "application/json"
  };
  Future<User> login(String email, String password) async {
    http.Response response = await http.post(
        Uri.parse(
          ApiSettings.login,
        ),
        body: {"email": email, "password": password});
    if (response.statusCode == 200) {
      return userFromJson(response.body);
    } else {
      return Future.error('failed to login');
    }
  }

  Future<void> addLink(String title, String link,
      {String? username, required BuildContext context}) async {
    http.Response response = await http.post(
        Uri.parse(
          ApiSettings.links,
        ),
        body: {
          "title": title,
          "link": link,
          "isActive": "1",
          "username": username
        },
        headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    if (response.statusCode == 200) {
      showAlert(context, message: 'link is add successfully', isError: false);
    } else {
      showAlert(context, message: 'cant add link');
    }
  }

  Future<void> register(
    BuildContext context, {
    required String email,
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    http.Response response = await http.post(
        Uri.parse(
          ApiSettings.register,
        ),
        body: {
          "name": name,
          "email": email,
          "password": password,
          "password_confirmation": passwordConfirmation
        });
    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    } else {
      return Future.error('failed to register');
    }
  }

  Future<List<UserClass>> search(String name,
      {required BuildContext context}) async {
    http.Response response = await http.post(
        Uri.parse(
          ApiSettings.search,
        ),
        body: {
          "name": name,
        },
        headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['user'] as List<dynamic>;

      return data.map((e) => UserClass.fromJson(e)).toList();
    }

    return Future.error('Somthing wrong');
  }

  Future<void> follow(BuildContext context, int id) async {
    http.Response response = await http.post(
        Uri.parse(
          ApiSettings.follow,
        ),
        body: {
          "followee_id": id.toString(),
        },
        headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    if (response.statusCode == 200) {
      showAlert(context,
          message: 'follow is done successfully', isError: false);
    } else {
      showAlert(context, message: 'error in follow');
    }
  }

  Future<FollowData> getFollowData(BuildContext context) async {
    final response =
        await http.get(Uri.parse(ApiSettings.follow), headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return FollowData.fromJson(data);

      // return data.map((e) => FollowData.fromJson(e)).toList();
    }

    return Future.error('Somthing wrong');
  }

  Future<bool> editLink(BuildContext context, Link model) async {
    http.Response response = await http.put(
        Uri.parse(
          ApiSettings.editLink.replaceAll('{id}', model.id.toString()),
        ),
        body: {
          "title": model.title,
          "link": model.link,
          "isActive": "${model.isActive ?? 1}",
          "username": model.username
        },
        headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    if (response.statusCode == 200) {
      showAlert(context,
          message: 'The link has been modified successfully', isError: false);
      return true;
    } else {
      showAlert(context, message: 'error in modifying link');
      return false;
    }
  }

  Future<bool> deleteLink(BuildContext context, int id) async {
    http.Response response = await http.delete(
        Uri.parse(
          ApiSettings.deleteLink.replaceAll('{id}', id.toString()),
        ),
        headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    if (response.statusCode == 200) {
      showAlert(
        context,
        message: 'The link has been deleted successfully',
        isError: false,
      );
      return true;
    } else {
      showAlert(
        context,
        message: 'error in deleting link',
      );
      return false;
    }
  }

  Future<bool> updateLocation(
      BuildContext context, int id, double lat, double long) async {
    print('lat $lat');
    print('long $long');
    http.Response response = await http.put(
        Uri.parse(
          ApiSettings.updateLocation.replaceAll('{id}', id.toString()),
        ),
        body: {
          "lat": lat.toString(),
          "long": long.toString(),
        },
        headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    print(response.body);
    if (response.statusCode == 200) {
      showAlert(context,
          message: 'The location has been updating successfully',
          isError: false);
      return true;
    } else {
      showAlert(context, message: 'error in updating location');
      return false;
    }
  }

  Future<bool> setActiveSharing(
      BuildContext context, int id, String type) async {
    http.Response response = await http.post(
        Uri.parse(
          ApiSettings.activeSharing.replaceAll('{id}', id.toString()),
        ),
        body: {
          "type": type,
        },
        headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    Map<String, dynamic> data = jsonDecode(response.body);
    print(data);

    if (response.statusCode == 200) {
      showAlert(context,
          message: 'The Sharing type is set successfully', isError: false);
      return true;
    } else {
      showAlert(context, message: 'error in seting  sharing type');
      return false;
    }
  }

  Future<bool> removeActiveSharing(BuildContext context, int id) async {
    http.Response response = await http.delete(
        Uri.parse(
          ApiSettings.activeSharing.replaceAll('{id}', id.toString()),
        ),
        headers: headers);
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    print('type ${response.body}');
    if (response.statusCode == 200) {
      showAlert(context,
          message: 'The Active Sharing is removed successfully',
          isError: false);
      return true;
    } else {
      showAlert(context, message: 'error in removeing active sharing ');
      return false;
    }
  }

  Future<Sender> getNearesSender(BuildContext context, int id) async {
    final response = await http.get(
      Uri.parse(ApiSettings.nearestSender.replaceAll('{id}', id.toString())),
      headers: headers,
    );
    if (response.statusCode == 401) {
      Navigator.pushReplacementNamed(context, LoginView.id);
    }
    if (response.statusCode == 200) {
      return senderFromJson(response.body);
    }

    return Future.error('Somthing wrong');
  }
}
