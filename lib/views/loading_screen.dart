import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/views/login_view.dart';

import '../controllers/shared_helper.dart';
import 'main_app_view.dart';
import 'onbording_view.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  void checkLogin() async {
    String path;
    await Future.delayed(const Duration(seconds: 2));
    SharedHelper temp = SharedHelper();
    if (temp.getIsFirst()) {
      path = OnBoardingView.id;
    } else {
      if (temp.getToken().isNotEmpty) {
        path = MainAppView.id;
      } else {
        path = LoginView.id;
      }
    }

    if (mounted) {
      Navigator.pushReplacementNamed(
        context,
        path,
      );
    }
  }

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
