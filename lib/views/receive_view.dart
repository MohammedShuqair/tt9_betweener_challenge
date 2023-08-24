import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tt9_betweener_challenge/controllers/api_helper.dart';
import 'package:tt9_betweener_challenge/controllers/shared_helper.dart';
import 'package:tt9_betweener_challenge/models/follow_data.dart';
import 'package:tt9_betweener_challenge/models/sender.dart';
import 'package:tt9_betweener_challenge/views/widgets/network_error_message.dart';
import 'package:tt9_betweener_challenge/views/widgets/profile_appbar.dart';
import 'package:tt9_betweener_challenge/views/widgets/sub_appbar.dart';

import '../constants.dart';
import '../features/auth/model/user.dart';
import 'account_profile_view.dart';

class ReceiveView extends StatefulWidget {
  static String id = '/receiveView';

  const ReceiveView({super.key});

  @override
  State<ReceiveView> createState() => _ReceiveViewState();
}

class _ReceiveViewState extends State<ReceiveView> {
  late Future<Sender> _future;
  Sender? sender;
  late Future<FollowData> _futureFollow;
  FollowData? followData;
  @override
  void initState() {
    _futureFollow = ApiHelper().getFollowData(context);

    _future = ApiHelper().getNearesSender(
        context, userFromJson(SharedHelper().getUser()).user!.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SubAppBar(
        hint: 'Receiver',
      ),
      body: FutureBuilder<FollowData>(
          future: _futureFollow,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              followData = snapshot.data;
              return Column(
                children: [
                  const SizedBox(
                    height: 38,
                  ),
                  SvgPicture.asset('assets/imgs/a_sharing.svg'),
                  const SizedBox(
                    height: 28,
                  ),
                  FutureBuilder<Sender>(
                      future: _future,
                      builder: (context, snapshot) {
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          sender = snapshot.data;
                          List<NearestSender>? nSender = sender?.nearestSender;
                          nSender?.sort((a, b) =>
                              a.distance!.compareTo(b.distance as num));
                          return ListView.separated(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                bool isFollowed = followData!.following.any(
                                    (person) =>
                                        person.id == nSender?[index].userId!);
                                return ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => AccountProfileView(
                                                  user: nSender![index].user!,
                                                  isFollowed: isFollowed,
                                                )));
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                          color: kPrimaryColor)),
                                  title: Text(
                                    nSender?[index].user?.name ?? 'c',
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  subtitle: Text(
                                    nSender?[index].user?.email ?? '',
                                    style: const TextStyle(color: Colors.black),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  trailing: isFollowed
                                      ? null
                                      : TextButton(
                                          child: const Text(
                                            'follow',
                                          ),
                                          onPressed: () async {
                                            await ApiHelper().follow(context,
                                                nSender![index].userId!);
                                          },
                                        ),
                                );
                              },
                              separatorBuilder: (_, context) => const SizedBox(
                                    height: 8,
                                  ),
                              itemCount: sender?.count ?? 0);
                        }
                        if (snapshot.hasError) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 18.0),
                            child: NetworkErrorMessage(),
                          );
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 38.0),
                            child: LinearProgressIndicator(),
                          );
                        }
                        return const SizedBox();
                      })
                ],
              );
            }
            if (snapshot.hasError) {
              return Center(child: NetworkErrorMessage());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: LinearProgressIndicator());
            }
            return const SizedBox();
          }),
    );
  }
}
