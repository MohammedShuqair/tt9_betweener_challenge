import 'package:tt9_betweener_challenge/controllers/shared_helper.dart';
import 'package:tt9_betweener_challenge/models/user.dart';

User getLocalUser() {
  SharedHelper helper = SharedHelper();
  return userFromJson(helper.getUser());
}