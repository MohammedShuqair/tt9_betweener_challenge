import 'package:tt9_betweener_challenge/core/util/api_base_helper.dart';
import '../../../controllers/api_settings.dart';
import '../model/user.dart';

class AuthRepository {
  final ApiBaseHelper _helper = ApiBaseHelper();

  Future<User> login(String email, String password) async {
    final response = await _helper.post(
      ApiSettings.login,
      {"email": email, "password": password},
    );
    return User.fromJson(response);
  }

  Future<void> register(
    String email,
    String name,
    String password,
    String passwordConfirmation,
  ) async {
    await _helper.post(ApiSettings.register, {
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation
    });
  }
}
