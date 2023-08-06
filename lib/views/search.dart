import 'package:flutter/material.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/api_helper.dart';
import 'package:tt9_betweener_challenge/views/account_profile_view.dart';
import 'package:tt9_betweener_challenge/views/widgets/custom_text_form_field.dart';
import 'package:tt9_betweener_challenge/views/widgets/network_error_message.dart';

import '../models/follow_data.dart';
import '../models/user.dart';

class SearchScreen extends StatefulWidget {
  static String id = "/search_screen";

  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<List<UserClass>>? _future;
  late Future<FollowData> _futureFollow;
  FollowData? followData;
  List<UserClass> users = [];
  @override
  void initState() {
    _futureFollow = ApiHelper().getFollowData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightPrimaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Search",
          style: regularStyle.copyWith(fontWeight: FontWeight.w500),
        ),
      ),
      body: FutureBuilder<FollowData>(
          future: _futureFollow,
          builder: (context, snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              followData = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 38.0),
                      CustomTextFormField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            print(value);
                            _future =
                                ApiHelper().search(value, context: context);
                            setState(() {});
                          }
                        },
                        hint: 'Search by name',
                        label: 'Search',
                      ),
                      const SizedBox(
                        height: 18,
                      ),
                      if (_future != null) ...{
                        FutureBuilder<List<UserClass>>(
                            future: _future,
                            builder: (context, snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                users = snapshot.data ?? [];
                                return ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) {
                                    bool isFollowed = followData!.following.any(
                                        (person) =>
                                            person.id == users[index].id!);
                                    return ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    AccountProfileView(
                                                      user: users[index],
                                                      isFollowed: isFollowed,
                                                    )));
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: const BorderSide(
                                              color: kPrimaryColor)),
                                      title: Text(
                                        users[index].name ?? 'c',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                      subtitle: Text(
                                        users[index].email ?? '',
                                        style: const TextStyle(
                                            color: Colors.black),
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
                                                await ApiHelper().follow(
                                                    context, users[index].id!);
                                              },
                                            ),
                                    );
                                  },
                                  separatorBuilder: (_, index) =>
                                      const SizedBox(
                                    height: 12,
                                  ),
                                  itemCount: users.length,
                                );
                              } else {
                                return const CircularProgressIndicator();
                              }
                            })
                      },
                      const SizedBox(height: 38.0),
                    ],
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: NetworkErrorMessage(),
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}