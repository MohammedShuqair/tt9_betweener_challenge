import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/shared_helper.dart';
import 'package:tt9_betweener_challenge/views/login_view.dart';
import 'package:tt9_betweener_challenge/views/qr_scanner_view.dart';

import '../search.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        icon: Icon(
          Icons.logout,
          color: kPrimaryColor,
        ),
        onPressed: () async {
          await SharedHelper().setUser('');
          await SharedHelper().setToken('');

          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (_) => LoginView()), (route) => true);
        },
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.id);
            },
            icon: const Icon(Icons.search, color: kPrimaryColor)),
        IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => QrScannerView()));
            },
            icon: const Icon(Icons.qr_code_scanner, color: kPrimaryColor)),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
