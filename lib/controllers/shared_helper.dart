import 'package:shared_preferences/shared_preferences.dart';

class SharedHelper {
  SharedHelper._();
  static final SharedHelper _instance = SharedHelper._();
  factory SharedHelper() {
    return _instance;
  }
  late SharedPreferences sharedPreferences;
  Future<void> init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String token) async {
    await sharedPreferences.setString('token', token);
  }

  String getToken() {
    return sharedPreferences.getString('token') ?? '';
  }

  Future<void> setIsFirst(bool value) async {
    await sharedPreferences.setBool('isFirst', value);
  }

  bool getIsFirst() {
    return sharedPreferences.getBool('isFirst') ?? true;
  }

  Future<void> setUser(String user) async {
    await sharedPreferences.setString('user', user);
  }

  String getUser() {
    return sharedPreferences.getString('user') ?? '';
  }
}
