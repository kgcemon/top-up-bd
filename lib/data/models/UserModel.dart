// To parse this JSON data, do
//
//     final userData = userDataFromJson(jsonString);

import 'dart:convert';

UserData userDataFromJson(String str) => UserData.fromJson(json.decode(str));

String userDataToJson(UserData data) => json.encode(data.toJson());

class UserData {
  String message;
  String token;
  User user;

  UserData({
    required this.message,
    required this.token,
    required this.user,
  });

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    message: json["message"],
    token: json["token"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "token": token,
    "user": user.toJson(),
  };
}

class User {
  int id;
  DateTime dateTime;
  String? username;
  String? phonenumber;
  dynamic googleId;
  dynamic email;
  DateTime createdAt;
  dynamic updatedAt;

  User({
    required this.id,
    required this.dateTime,
    required this.username,
    required this.phonenumber,
    required this.googleId,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    dateTime: DateTime.parse(json["date_time"]),
    username: json["username"] ?? '',
    phonenumber: json["phonenumber"] ?? '',
    googleId: json["google_id"],
    email: json["email"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "date_time": dateTime.toIso8601String(),
    "username": username,
    "phonenumber": phonenumber,
    "google_id": googleId,
    "email": email,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt,
  };
}
