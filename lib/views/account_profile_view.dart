import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:tt9_betweener_challenge/views/profile_view.dart';

import '../constants.dart';
import '../controllers/api_helper.dart';

class AccountProfileView extends StatelessWidget {
  const AccountProfileView(
      {Key? key, required this.user, required this.isFollowed})
      : super(key: key);
  final UserClass user;
  final bool isFollowed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: kPrimaryColor,
          ),
        ),
        title: Text(
          user.name ?? 'name',
          style: const TextStyle(color: kPrimaryColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(
                height: 24.0,
              ),
              AccountProfileData(
                  name: user.name ?? 'name',
                  email: user.email ?? 'email',
                  id: user.id!,
                  isFollowed: isFollowed),
              if (user.links != null)
                ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      bool isEven = index % 2 == 0;
                      Color backgroundColor =
                          isEven ? kLightDangerColor : kLightPrimaryColor;
                      Color foregroundColor =
                          isEven ? kOnLightDangerColor : kLinksColor;

                      return ProfileLinkWidget(
                          backgroundColor: backgroundColor,
                          link: user.links![index],
                          foregroundColor: foregroundColor);
                    },
                    separatorBuilder: (_, index) => const SizedBox(
                          height: 28,
                        ),
                    itemCount: user.links?.length ?? 0)
            ],
          ),
        ),
      ),
    );
  }
}

class AccountProfileData extends StatelessWidget {
  const AccountProfileData({
    Key? key,
    required this.name,
    required this.email,
    required this.isFollowed,
    required this.id,
  }) : super(key: key);

  final String name;
  final String email;
  final bool isFollowed;
  final int id;

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
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
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (!isFollowed)
                    InkWell(
                      onTap: () async {
                        await ApiHelper().follow(context, id);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18.0, vertical: 4),
                          decoration: BoxDecoration(
                              color: kSecondaryColor,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text('Follow')),
                    )
                ],
              ),
            )
          ],
        ));
  }
}
