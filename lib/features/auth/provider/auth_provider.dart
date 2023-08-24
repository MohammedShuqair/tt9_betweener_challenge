import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/core/util/api_response.dart';
import 'package:tt9_betweener_challenge/features/auth/reop/auth_repository.dart';

import '../model/user.dart';

class AuthProvider extends ChangeNotifier {
  late AuthRepository _repository;
  late ApiResponse<User> loginResponse;
  late ApiResponse<bool> registerResponse;
  AuthProvider() {
    _repository = AuthRepository();
  }
  Future<void> loginUser(String email, String password) async {
    loginResponse = ApiResponse.loading('wait...');
    notifyListeners();
    try {
      final User user = await _repository.login(email, password);
      loginResponse = ApiResponse.completed(user)
        ..message = 'login completed successfully';
      notifyListeners();
    } catch (e, s) {
      print(e.toString());
      print(s.toString());
      loginResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }

  void registerUser({
    required String email,
    required String name,
    required String password,
    required String passwordConfirmation,
  }) async {
    registerResponse = ApiResponse.loading('wait...');
    notifyListeners();
    try {
      await _repository.register(email, name, password, passwordConfirmation);
      registerResponse = ApiResponse.completed(true)
        ..message = 'register completed successfully';
      notifyListeners();
    } catch (e) {
      registerResponse = ApiResponse.error(e.toString());
      notifyListeners();
    }
  }
}
