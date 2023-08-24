import 'dart:convert';

import 'package:tt9_betweener_challenge/features/auth/model/user.dart';

Sender senderFromJson(String str) => Sender.fromJson(json.decode(str));

String senderToJson(Sender data) => json.encode(data.toJson());

class Sender {
  int? count;
  List<NearestSender>? nearestSender;

  Sender({
    this.count,
    this.nearestSender,
  });

  factory Sender.fromJson(Map<String, dynamic> json) => Sender(
        count: json["count"],
        nearestSender: json["nearest-users"] == null
            ? []
            : List<NearestSender>.from(
                json["nearest-users"]!.map((x) => NearestSender.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "nearest-users": nearestSender == null
            ? []
            : List<dynamic>.from(nearestSender!.map((x) => x.toJson())),
      };
}

class NearestSender {
  int? id;
  int? userId;
  String? type;
  String? createdAt;
  String? updatedAt;
  double? distance;
  UserClass? user;

  NearestSender({
    this.id,
    this.userId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.distance,
    this.user,
  });

  factory NearestSender.fromJson(Map<String, dynamic> json) => NearestSender(
        id: json["id"],
        userId: json["user_id"],
        type: json["type"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        distance: json["distance"]?.toDouble(),
        user: json["user"] == null ? null : UserClass.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "type": type,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "distance": distance,
        "user": user?.toJson(),
      };
}
