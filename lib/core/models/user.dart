// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  final bool status;
  final Message message;
  final String data;

  User({
    required this.status,
    required this.message,
    required this.data,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    status: json["status"],
    message: Message.fromJson(json["message"]),
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message.toJson(),
    "data": data,
  };
}

class Message {
  final String token;
  final UserClass user;

  Message({
    required this.token,
    required this.user,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    token: json["token"],
    user: UserClass.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "user": user.toJson(),
  };
}

class UserClass {
  final int id;
  final String firstName;
  final dynamic middleName;
  final String lastName;
  final String phone;
  final String email;
  final String identityNumber;
  final bool isActive;
  final DateTime lastLoginAt;
  final dynamic governmentAgencyId;
  final dynamic emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserClass({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.identityNumber,
    required this.isActive,
    required this.lastLoginAt,
    required this.governmentAgencyId,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
    id: json["id"],
    firstName: json["first_name"],
    middleName: json["middle_name"],
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    identityNumber: json["identity_number"],
    isActive: json["is_active"],
    lastLoginAt: DateTime.parse(json["last_login_at"]),
    governmentAgencyId: json["government_agency_id"],
    emailVerifiedAt: json["email_verified_at"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "middle_name": middleName,
    "last_name": lastName,
    "phone": phone,
    "email": email,
    "identity_number": identityNumber,
    "is_active": isActive,
    "last_login_at": lastLoginAt.toIso8601String(),
    "government_agency_id": governmentAgencyId,
    "email_verified_at": emailVerifiedAt,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
