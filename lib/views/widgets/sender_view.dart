import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tt9_betweener_challenge/views/widgets/profile_appbar.dart';
import 'package:tt9_betweener_challenge/views/widgets/sub_appbar.dart';

import '../../constants.dart';

class SenderView extends StatelessWidget {
  static const String id = '/senderView';
  const SenderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SubAppBar(
        hint: 'Sender',
      ),
      body: Center(
        child: SvgPicture.asset(
          'assets/imgs/a_sharing.svg',
          color: kLightSecondaryColor,
        ),
      ),
    );
  }
}
