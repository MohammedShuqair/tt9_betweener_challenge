import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tt9_betweener_challenge/controllers/link_controller.dart';
import 'package:tt9_betweener_challenge/features/profile/links/model/link.dart';
import 'package:tt9_betweener_challenge/views/add_link_screen.dart';
import 'package:tt9_betweener_challenge/views/widgets/alert.dart';
import 'package:tt9_betweener_challenge/views/widgets/network_error_message.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';
import '../controllers/user_controller.dart';
import '../features/auth/model/user.dart';

class HomeView extends StatefulWidget {
  static String id = '/homeView';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<List<Link>> _future;
  List<Link> links = [];
  late User user;
  late bool portrait;

  @override
  void initState() {
    user = getLocalUser();
    _future = getLinks(context);
    super.initState();
  }

  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 18.0);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return OrientationBuilder(builder: (context, orientation) {
      portrait = orientation == Orientation.portrait;
      Widget hello = Padding(
        padding: padding,
        child: Text.rich(
          TextSpan(
              text: "Hello, ",
              style: titleStyle.copyWith(color: kPrimaryColor),
              children: [
                TextSpan(
                    text: user.user!.name?.toUpperCase(), style: titleStyle),
                TextSpan(
                  text: " !",
                  style: titleStyle.copyWith(color: kPrimaryColor),
                ),
              ]),
        ),
      );
      Widget qr = Expanded(
        flex: 3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RotatedBox(
                      quarterTurns: 1,
                      child: SvgPicture.asset('assets/imgs/qr_border.svg')),
                  RotatedBox(
                      quarterTurns: 2,
                      child: SvgPicture.asset('assets/imgs/qr_border.svg')),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RotatedBox(
                        quarterTurns: 0,
                        child: SvgPicture.asset('assets/imgs/qr_border.svg')),
                    RotatedBox(
                        quarterTurns: 3,
                        child: SvgPicture.asset('assets/imgs/qr_border.svg')),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18),
                child: Center(
                  child: QrImageView(
                    dataModuleStyle: const QrDataModuleStyle(
                        color: kPrimaryColor,
                        dataModuleShape: QrDataModuleShape.square),
                    eyeStyle: const QrEyeStyle(
                        color: kPrimaryColor, eyeShape: QrEyeShape.square),
                    data: '{'
                        '"id":"${user.user?.id}",'
                        '"name":"${user.user?.name}"}',
                    version: QrVersions.auto,
                    gapless: false,
                    errorStateBuilder: (cxt, err) {
                      return const Center(
                        child: Text(
                          'Something went wrong in showing qr code...',
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      // Widget qr = Expanded(
      //   flex: 3,
      //   child: Container(
      //     margin: padding,
      //     height: !portrait ? double.infinity : 300,
      //     width: portrait ? double.infinity : 300,
      //     color: Colors.purple,
      //   ),
      // );
      Widget divider = portrait
          ? Divider(
              indent: width / 5,
              endIndent: width / 5,
              thickness: 3,
              color: kPrimaryColor,
            )
          : Container(
              constraints: const BoxConstraints.expand(width: 3),
              height: double.infinity,
              // margin: EdgeInsets.symmetric(vertical: height / 20),
              color: kPrimaryColor,
            );
      Widget linkList = FutureBuilder<List<Link>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              links = snapshot.data ?? [];
              Widget widget = ListView.separated(
                  physics:
                      portrait ? null : const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: portrait ? Axis.horizontal : Axis.vertical,
                  itemBuilder: (_, index) {
                    List<Widget> widgets = [];
                    if (index == 0 && portrait) {
                      widgets.add(const SizedBox(
                        width: 12,
                      ));
                    }
                    if (index == links.length) {
                      Widget temp = InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, LinkScreen.addId)
                                .then((value) {
                              _future = getLinks(context);
                              setState(() {});
                            });
                          },
                          child: const AddLink());
                      if (portrait) {
                        widgets.add(Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            temp,
                            const SizedBox(
                              width: 18,
                            )
                          ],
                        ));
                      } else {
                        widgets.add(Expanded(
                          child: temp,
                        ));
                      }
                    } else {
                      Widget temp = LinkItem(
                        title: links[index].title ?? '',
                        username: links[index].username,
                        link: links[index].link ?? '',
                      );
                      if (portrait) {
                        widgets.add(temp);
                      } else {
                        widgets.add(Expanded(child: temp));
                      }
                    }
                    return Row(
                      mainAxisSize:
                          portrait ? MainAxisSize.min : MainAxisSize.max,
                      children: widgets,
                    );
                  },
                  separatorBuilder: (_, index) {
                    return portrait
                        ? const SizedBox(
                            width: 18,
                          )
                        : const SizedBox(
                            height: 8,
                          );
                  },
                  itemCount: links.length + 1);
              if (portrait) {
                return Expanded(child: widget);
              } else {
                return SizedBox(
                  width: width * 0.4,
                  child: widget,
                );
              }
            }
            if (snapshot.hasError) {
              Widget error = const NetworkErrorMessage();
              if (portrait) {
                return Expanded(
                  child: Center(
                    child: error,
                  ),
                );
              } else {
                return Center(
                  child: SizedBox(
                    width: width * 0.4,
                    child: error,
                  ),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              if (portrait) {
                return Expanded(
                    child: Center(
                  child: CircularProgressIndicator(),
                ));
              } else {
                return Center(
                  child: SizedBox(
                      width: width * 0.4, child: CircularProgressIndicator()),
                );
              }
            }
            return const SizedBox();
          });
      if (portrait) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 18, top: 38),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hello,
              const SizedBox(
                height: 38,
              ),
              qr,
              const SizedBox(
                height: 38,
              ),
              divider,
              const SizedBox(
                height: 38,
              ),
              linkList
            ],
          ),
        );
      } else {
        return Padding(
          padding: padding.copyWith(bottom: 8),
          child: Row(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    hello,
                    const SizedBox(
                      height: 8,
                    ),
                    linkList,
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 38,
              ),
              divider,
              const SizedBox(
                width: 38,
              ),
              qr
            ],
          ),
        );
      }
    });
  }
}

class LinkItem extends StatelessWidget {
  const LinkItem({
    super.key,
    required this.title,
    this.username,
    required this.link,
  });
  final String title;
  final String? username;
  final String link;
  Future<void> _launchUrl(BuildContext context) async {
    Uri uri = Uri.parse(link ?? '');
    if (await canLaunchUrl(uri)) {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        showAlert(context, message: 'something wont wrong please try catch');
      }
    } else {
      showAlert(context, message: 'link is in valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _launchUrl(context);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: kLightSecondaryColor,
            borderRadius: BorderRadius.circular(18)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.toUpperCase(),
              style: const TextStyle(
                  color: kOnSecondaryColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
            ),
            if (username != null)
              Text(
                username?[0] == "@"
                    ? username ?? 'name'
                    : "@${username ?? 'name'}",
                style: const TextStyle(color: kOnSecondaryColor, fontSize: 18),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
          ],
        ),
      ),
    );
  }
}

class AddLink extends StatelessWidget {
  const AddLink({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsetsDirectional.only(end: 18.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: kLightPrimaryColor, borderRadius: BorderRadius.circular(18)),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add,
            weight: 300,
          ),
          Text(
            'Add Link',
            style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
        ],
      ),
    );
  }
}
