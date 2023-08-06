import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:tt9_betweener_challenge/views/widgets/sub_appbar.dart';

import '../constants.dart';
import 'account_profile_view.dart';

class FollowList extends StatelessWidget {
  const FollowList(
      {Key? key,
      required this.users,
      required this.title,
      required this.isFollow})
      : super(key: key);
  final List<UserClass> users;
  final String title;
  final bool isFollow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SubAppBar(hint: title),
      body: users.isEmpty
          ? Center(
              child: Text('There is no ${title.toLowerCase()}'),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 28, horizontal: 18),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => AccountProfileView(
                                  user: users[index],
                                  isFollowed: isFollow,
                                )));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: kPrimaryColor)),
                  title: Text(
                    users[index].name ?? 'c',
                    style: const TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    users[index].email ?? '',
                    style: const TextStyle(color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
              separatorBuilder: (_, index) => const SizedBox(
                height: 12,
              ),
              itemCount: users.length,
            ),
    );
  }
}
