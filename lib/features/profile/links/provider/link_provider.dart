import 'package:flutter/cupertino.dart';
import 'package:tt9_betweener_challenge/features/profile/links/model/link.dart';
import '../../../../core/util/api_response.dart';
import '../reop/link_repository.dart';

class LinkProvider extends ChangeNotifier {
  late LinkRepository _linkRepository;

  late ApiResponse<List<Link>> _linkList;

  ApiResponse<List<Link>> get linkList => _linkList;

  LinkProvider() {
    _linkRepository = LinkRepository();
    fetchLinkList();
  }

  fetchLinkList() async {
    _linkList = ApiResponse.loading('Fetching Links');
    notifyListeners();
    try {
      List<Link> links = await _linkRepository.fetchLinkList();
      _linkList = ApiResponse.completed(links);
      notifyListeners();
    } catch (e) {
      _linkList = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
