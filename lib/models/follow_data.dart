// To parse this JSON data, do
//
//     final followData = followDataFromJson(jsonString);

import 'dart:convert';

import 'package:tt9_betweener_challenge/models/user.dart';

FollowData followDataFromJson(String str) =>
    FollowData.fromJson(json.decode(str));

// String followDataToJson(FollowData data) => json.encode(data.toJson());

class FollowData {
  int? followingCount;
  int? followersCount;
  List<UserClass> followers = [];
  List<UserClass> following = [];

  FollowData(
      {this.followingCount,
      this.followersCount,
      required this.followers,
      required this.following});

  factory FollowData.fromJson(Map<String, dynamic> json) {
    List frs = json["followers"] as List;
    List fing = json["following"] as List;
    return FollowData(
      followingCount: json["following_count"],
      followersCount: json["followers_count"],
      followers: frs.map((map) => UserClass.fromJson(map)).toList(),
      following: fing.map((map) => UserClass.fromJson(map)).toList(),
    );
  }

  // Map<String, dynamic> toJson() => {
  //       "following_count": followingCount,
  //       "followers_count": followersCount,
  //     };
}
