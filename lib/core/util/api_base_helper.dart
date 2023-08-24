import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../controllers/shared_helper.dart';
import 'app_exception.dart';

class ApiBaseHelper {
  Future<dynamic> get(String url, {Map<String, String>? header}) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(url), headers: header);
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, Map<String, String> body,
      {Map<String, String>? header}) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: header,
        body: body,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } catch (e) {
      print(e.toString());
    }
    return responseJson;
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    var responseJson;
    try {
      final response = await http.put(
        Uri.parse(url),
        body: body,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    var responseJson = json.decode(response.body.toString());
    switch (response.statusCode) {
      case 200:
        return responseJson;
      case 400:
        throw BadRequestException(responseJson['message']);
      case 401:
      case 403:
        throw UnauthorisedException(responseJson['message']);
      case 500:
      default:
        throw FetchDataException(
            'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
    }
  }
}
