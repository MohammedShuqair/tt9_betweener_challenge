import 'package:tt9_betweener_challenge/controllers/api_settings.dart';
import 'package:tt9_betweener_challenge/controllers/shared_helper.dart';
import 'package:tt9_betweener_challenge/core/util/api_base_helper.dart';
import 'package:tt9_betweener_challenge/features/profile/links/model/link.dart';

class LinkRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Map<String, String> headers = {
    'Authorization': 'Bearer ${SharedHelper().getToken()}',
    'Accept': "application/json"
  };

  Future<List<Link>> fetchLinkList() async {
    final response = await _helper.get(ApiSettings.links, header: headers);
    List<Map<String, dynamic>> links = response['links'];
    return links.map((map) => Link.fromJson(map)).toList();
  }

  // Future<dynamic> addLink() async {
  //   final response = await _helper.post(ApiSettings.links, {});
  //   return LinkResponse.fromJson(response).results;
  // }
}
