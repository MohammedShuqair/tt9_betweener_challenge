import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/api_helper.dart';
import 'package:tt9_betweener_challenge/controllers/shared_helper.dart';
import 'package:tt9_betweener_challenge/models/follow_data.dart';
import 'package:tt9_betweener_challenge/models/link.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:tt9_betweener_challenge/views/add_link_screen.dart';
import 'package:tt9_betweener_challenge/views/widgets/alert.dart';
import 'package:tt9_betweener_challenge/views/widgets/network_error_message.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/link_controller.dart';

class ProfileView extends StatefulWidget {
  static String id = '/profileView';

  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<List<Link>> _futureLinks;
  List<Link> links = [];

  @override
  void initState() {
    _futureLinks = getLinks(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 24.0,
                ),
                const ProfileData(),
                FutureBuilder<List<Link>>(
                    future: _futureLinks,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        links = snapshot.data ?? [];
                        return ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                              vertical: 24,
                            ),
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              bool isEven = index % 2 == 0;
                              Color backgroundColor = isEven
                                  ? kLightDangerColor
                                  : kLightPrimaryColor;
                              Color foregroundColor =
                                  isEven ? kOnLightDangerColor : kLinksColor;

                              return Slidable(
                                endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      const Spacer(),
                                      CustomSlidableAction(
                                        flex: 5,
                                        padding: EdgeInsets.zero,
                                        onPressed: (BuildContext context) {
                                          Navigator.push<bool>(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      LinkScreen.edit(
                                                        link: links[index],
                                                      ))).then((bool? value) {
                                            if (value != null && value) {
                                              _futureLinks = getLinks(context);
                                              setState(() {});
                                            }
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(18),
                                        backgroundColor: kSecondaryColor,
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                      const Spacer(),
                                      CustomSlidableAction(
                                        flex: 5,
                                        onPressed:
                                            (BuildContext context) async {
                                          showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: const Text(
                                                        'Confirm link deletion'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () async {
                                                            bool result =
                                                                await ApiHelper()
                                                                    .deleteLink(
                                                                        context,
                                                                        links[index]
                                                                            .id!);
                                                            if (mounted) {
                                                              Navigator.pop(
                                                                  context,
                                                                  result);
                                                            }
                                                          },
                                                          child: const Text(
                                                              'confirm')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context, false);
                                                          },
                                                          child: const Text(
                                                              'cancel')),
                                                    ],
                                                  )).then((result) {
                                            if (result != null && result) {
                                              _futureLinks = getLinks(context);
                                              setState(() {});
                                            }
                                          });
                                        },
                                        padding: EdgeInsets.zero,
                                        borderRadius: BorderRadius.circular(18),
                                        backgroundColor: kDangerColor,
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 40,
                                        ),
                                      ),
                                    ]),
                                child: ProfileLinkWidget(
                                    backgroundColor: backgroundColor,
                                    link: links[index],
                                    foregroundColor: foregroundColor),
                              );
                            },
                            separatorBuilder: (_, index) => const SizedBox(
                                  height: 28,
                                ),
                            itemCount: links.length);
                      }
                      if (snapshot.hasError) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 18.0),
                          child: NetworkErrorMessage(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 38.0),
                          child: LinearProgressIndicator(),
                        );
                      }
                      return const SizedBox();
                    }),
                const SizedBox(
                  height: 24.0,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, LinkScreen.addId).then((value) {
                    _futureLinks = getLinks(context);
                    setState(() {});
                  });
                },
                backgroundColor: kPrimaryColor,
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSlidAction extends StatelessWidget {
  const CustomSlidAction({
    super.key,
    required this.backgroundColor,
    required this.icon,
  });
  final Color backgroundColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsetsDirectional.only(start: 12),
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Icon(
        icon,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}

class ProfileData extends StatefulWidget {
  const ProfileData({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileData> createState() => _ProfileDataState();
}

class _ProfileDataState extends State<ProfileData> {
  late Future<FollowData> _future;
  FollowData? followData;
  UserClass? user;
  late String name;
  late String email;
  String? followers;
  String? following;
  bool getFollowError = false;

  String formatFollow(int category, int num) {
    if (num % category == 0) {
      return (num / category).toStringAsFixed(0);
    }
    return (num / category).toString().substring(0, 3);
  }

  String followCount(int number) {
    String temp;
    if (number < 1000) {
      temp = number.toString();
    } else if (number < 1000000) {
      temp = '${formatFollow(1000, number)} k';
    } else if (number < 1000000000) {
      temp = '${formatFollow(1000000, number)} m';
    } else {
      temp = '${formatFollow(1000000000, number)} t';
    }
    return temp;
  }

  void setData() {
    setState(() {
      name = user?.name ?? '';
      email = user?.email ?? '';
    });
  }

  @override
  void initState() {
    _future = ApiHelper().getFollowData(context);
    _future.then((value) {
      print(value.followers.first.email);
      followers = followCount(value.followersCount ?? 0);
      following = followCount(value.followingCount ?? 0);
      setState(() {});
    }).catchError((e) {
      setState(() {
        getFollowError = true;
      });
    });
    user = userFromJson(SharedHelper().getUser()).user;
    setData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: kPrimaryColor, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsetsDirectional.only(
            start: 24, top: 8, bottom: 12, end: 12),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 18,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 18,
                      ),
                      Text(
                        name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                      Text(
                        email,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // FutureBuilder<FollowData>(
                      //     future: _future,
                      //     builder: (context, snapshot) {
                      //       if (snapshot.hasData) {
                      //         followData = snapshot.data;
                      //         followers = followData?.followersCount ?? 0;
                      //         following = followData?.followingCount ?? 0;
                      //         return Row(
                      //           children: [
                      //             Container(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 8.0, vertical: 4),
                      //               decoration: BoxDecoration(
                      //                   color: kSecondaryColor,
                      //                   borderRadius: BorderRadius.circular(12)),
                      //               child: Text("followers $followers"),
                      //             ),
                      //             const SizedBox(
                      //               width: 8,
                      //             ),
                      //             Container(
                      //               padding: const EdgeInsets.symmetric(
                      //                   horizontal: 8.0, vertical: 4),
                      //               decoration: BoxDecoration(
                      //                   color: kSecondaryColor,
                      //                   borderRadius: BorderRadius.circular(12)),
                      //               child: Text("following $following"),
                      //             ),
                      //           ],
                      //         );
                      //       }
                      //       if (snapshot.hasError) {
                      //         print(snapshot.error.toString());
                      //         print(snapshot.stackTrace);
                      //         return const SizedBox();
                      //       }
                      //       return const Text('loading');
                      //     }),
                      Row(
                        children: [
                          Expanded(
                            child: FollowInfo(
                              hint: 'followers',
                              number: followers,
                              isError: getFollowError,
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: FollowInfo(
                              hint: 'following',
                              number: following,
                              isError: getFollowError,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  IconButton(
                      onPressed: () {},
                      highlightColor: Colors.white.withOpacity(0.5),
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.white,
                      ))
                ],
              ),
            )
          ],
        ));
  }
}

class FollowInfo extends StatelessWidget {
  const FollowInfo({
    super.key,
    required this.hint,
    required this.number,
    required this.isError,
  });
  final String hint;

  final String? number;
  final bool isError;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
        decoration: BoxDecoration(
            color: kSecondaryColor, borderRadius: BorderRadius.circular(12)),
        child: Text.rich(
          TextSpan(
            text: "$hint ",
            children: [
              if (number == null && !isError) ...{
                const WidgetSpan(
                    child: Center(
                        child: SizedBox(
                            height: 8,
                            width: 8,
                            child: CircularProgressIndicator()))),
              } else ...{
                TextSpan(text: isError ? '-' : number),
              }
            ],
          ),
        ));
  }
}

class ProfileLinkWidget extends StatelessWidget {
  const ProfileLinkWidget({
    super.key,
    required this.backgroundColor,
    required this.link,
    required this.foregroundColor,
  });

  final Color backgroundColor;
  final Link link;
  final Color foregroundColor;
  void lunchFaceInAPP() async {
    String? pageId = link.link?.substring(link.link!.lastIndexOf('?id=') + 4);
    print("page id ${pageId}");
    String fbProtocolUrl;

    if (Platform.isIOS) {
      fbProtocolUrl = 'fb://profile/$pageId';
    } else {
      fbProtocolUrl = 'fb://page/$pageId';
    }

    try {
      bool launched = await launch(fbProtocolUrl, forceSafariVC: false);

      if (!launched) {
        await launch(link.link!, forceSafariVC: false);
      }
    } catch (e) {
      await launch(link.link!, forceSafariVC: false);
    }
  }

  Future<void> _launchUrl(BuildContext context) async {
    Uri uri = Uri.parse(link.link ?? '');
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
        // lunchFaceInAPP();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              link.title?.toUpperCase() ?? '',
              style: TextStyle(
                  letterSpacing: 5, fontSize: 20, color: foregroundColor),
            ),
            Text(
              link.link ?? '',
              style: TextStyle(fontSize: 14, color: foregroundColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
