import 'package:flutter/material.dart';

import '../../constants.dart';

class SubAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SubAppBar({
    super.key,
    required this.hint,
  });
  final String hint;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: kLightPrimaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        hint,
        style: regularStyle.copyWith(fontWeight: FontWeight.w500),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(60);
}
