import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/api_helper.dart';
import 'package:tt9_betweener_challenge/controllers/location.dart';
import 'package:tt9_betweener_challenge/controllers/shared_helper.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:tt9_betweener_challenge/views/receive_view.dart';
import 'package:tt9_betweener_challenge/views/widgets/sender_view.dart';
import 'package:tt9_betweener_challenge/views/widgets/network_error_message.dart';

class ActiveSharing extends StatefulWidget {
  const ActiveSharing({Key? key}) : super(key: key);

  @override
  State<ActiveSharing> createState() => _ActiveSharingState();
}

class _ActiveSharingState extends State<ActiveSharing> {
  late int id;
  Future<Location> getLocation() async {
    Location location = Location();
    await location.getCurrentLocation();
    return location;
  }

  Future<bool> updateUserLocation(Location location) async {
    return await ApiHelper()
        .updateLocation(context, id, location.lat, location.long);
  }

  Future<bool> setSharingType(String type) async {
    return await ApiHelper().setActiveSharing(context, id, type);
  }

  Future<bool> algorithm() async {
    Location location = await getLocation().catchError((e) {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: NetworkErrorMessage(
                  hint:
                      'Please give the app permission to determine your current location',
                ),
              ));
    });
    print('false');
    bool done = await updateUserLocation(location).catchError((e) {
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: NetworkErrorMessage(),
              ));
    });
    if (done) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    id = userFromJson(SharedHelper().getUser()).user!.id!;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 38),
      child: Column(
        children: [
          Text(
            'Do you want to be a sender or receiver',
            style: titleStyle.copyWith(color: kPrimaryColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 58,
          ),
          Expanded(
            child: CustomButton(
              onTap: () async {
                if (await algorithm()) {
                  bool done = await setSharingType('sender').catchError((e) {
                    showDialog(
                        context: context,
                        builder: (_) => const AlertDialog(
                              content: NetworkErrorMessage(),
                            ));
                  });
                  if (done && mounted) {
                    Navigator.pushNamed(context, SenderView.id)
                        .then((value) async {
                      await ApiHelper().removeActiveSharing(context, id);
                    });
                  }
                }
              },
              hint: 'Sender',
            ),
          ),
          SizedBox(
            height: 28,
          ),
          Expanded(
            child: CustomButton(
              onTap: () async {
                Navigator.pushNamed(context, ReceiveView.id);
              },
              isReceiver: true,
              hint: 'Receiver',
            ),
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.hint,
    this.isReceiver = false,
  });
  final VoidCallback onTap;
  final String hint;
  final bool isReceiver;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isReceiver ? kLightPrimaryColor : kLightSecondaryColor,
        ),
        child: Text(
          hint,
          style: TextStyle(
              color: isReceiver ? kLinksColor : Colors.black,
              fontSize: 38,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
