import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tt9_betweener_challenge/features/profile/links/provider/link_provider.dart';
import 'package:tt9_betweener_challenge/views/home_view.dart';
import 'package:tt9_betweener_challenge/views/profile_view.dart';
import 'package:tt9_betweener_challenge/views/receive_view.dart';
import 'package:tt9_betweener_challenge/views/widgets/custom_floating_nav_bar.dart';
import 'package:tt9_betweener_challenge/views/widgets/main_appbar.dart';
import 'package:tt9_betweener_challenge/views/widgets/profile_appbar.dart';

import 'active_sharing.dart';

class MainAppView extends StatefulWidget {
  static String id = '/mainAppView';

  const MainAppView({super.key});

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  int _currentIndex = 1;
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: 1);
    super.initState();
  }

  late List<Widget> screensList = [
    const ActiveSharing(),
    const HomeView(),
    const ProfileView()
  ];

  List<PreferredSizeWidget> appbars = [
    const SecondaryAppBar(
      hint: 'Active Sharing',
    ),
    const MainAppBar(),
    const SecondaryAppBar(
      hint: "Profile",
    ),
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LinkProvider(),
      child: Scaffold(
        appBar: appbars[_currentIndex],
        body: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: screensList,
        ),
        // extendBody: true,
        bottomNavigationBar: CustomFloatingNavBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            controller.jumpToPage(index);
          },
        ),
      ),
    );
  }
}
