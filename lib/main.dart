import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tt9_betweener_challenge/views/add_link_screen.dart';
import 'package:tt9_betweener_challenge/views/home_view.dart';
import 'package:tt9_betweener_challenge/views/loading_screen.dart';
import 'package:tt9_betweener_challenge/views/login_view.dart';
import 'package:tt9_betweener_challenge/views/main_app_view.dart';
import 'package:tt9_betweener_challenge/views/onbording_view.dart';
import 'package:tt9_betweener_challenge/views/profile_view.dart';
import 'package:tt9_betweener_challenge/views/receive_view.dart';
import 'package:tt9_betweener_challenge/views/register_view.dart';
import 'package:tt9_betweener_challenge/views/search.dart';
import 'package:tt9_betweener_challenge/views/widgets/sender_view.dart';

import 'constants.dart';
import 'controllers/shared_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedHelper helper = SharedHelper();
  await helper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Betweener',
      theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: kPrimaryColor,
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: kPrimaryColor,
          ),
          appBarTheme: const AppBarTheme(
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark),
            titleTextStyle: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor),
          ),
          scaffoldBackgroundColor: kScaffoldColor),
      home: const LoadingScreen(),
      routes: {
        OnBoardingView.id: (context) => const OnBoardingView(),
        LoginView.id: (context) => const LoginView(),
        RegisterView.id: (context) => const RegisterView(),
        HomeView.id: (context) => const HomeView(),
        MainAppView.id: (context) => const MainAppView(),
        ProfileView.id: (context) => const ProfileView(),
        ReceiveView.id: (context) => const ReceiveView(),
        LinkScreen.addId: (context) => const LinkScreen.add(),
        SearchScreen.id: (context) => const SearchScreen(),
        SenderView.id: (context) => const SenderView(),
      },
    );
  }
}
