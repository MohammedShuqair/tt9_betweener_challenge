// To parse this JSON data, do
//
//     final link = linkFromJson(jsonString);

import 'dart:convert';

Link linkFromJson(String str) => Link.fromJson(json.decode(str));

String linkToJson(Link data) => json.encode(data.toJson());

class Link {
  int? id;
  String? title;
  String? link;
  String? username;
  String? isActive;
  String? userId;
  String? createdAt;
  String? updatedAt;

  Link({
    this.id,
    this.title,
    this.link,
    this.username,
    this.isActive,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  Link copyWith({
    int? id,
    String? title,
    String? link,
    String? username,
    String? isActive,
    String? userId,
    String? createdAt,
    String? updatedAt,
  }) {
    return Link(
      id: id ?? this.id,
      title: title ?? this.title,
      link: link ?? this.link,
      username: username ?? this.username,
      isActive: isActive ?? this.isActive,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        id: json["id"],
        title: json["title"],
        link: json["link"],
        username: json["username"],
        isActive: json["isActive"],
        userId: json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "link": link,
        "username": username,
        "isActive": isActive,
        "user_id": userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
