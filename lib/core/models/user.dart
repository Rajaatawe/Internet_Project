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
  final String? firstName;
  final String? middleName; // يمكن أن تكون null
  final String? lastName;
  final String? phone;
  final String ?email;
  final String ?identityNumber;
  final bool isActive;
  final DateTime lastLoginAt;
  final int? governmentAgencyId; // يمكن أن تكون null
  final DateTime? emailVerifiedAt; // يمكن أن تكون null


  UserClass({
    required this.id,
    required this.firstName,
    this.middleName, // يمكن أن تكون null
    required this.lastName,
    required this.phone,
    required this.email,
    required this.identityNumber,
    required this.isActive,
    required this.lastLoginAt,
    this.governmentAgencyId, // يمكن أن تكون null
    this.emailVerifiedAt, // يمكن أن تكون null

  });

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
    id: json["id"],
    firstName: json["first_name"],
    middleName: json["middle_name"], // يمكن أن تكون null
    lastName: json["last_name"],
    phone: json["phone"],
    email: json["email"],
    identityNumber: json["identity_number"],
    isActive: json["is_active"] ?? false,
    lastLoginAt: DateTime.parse(json["last_login_at"]),
    governmentAgencyId: json["government_agency_id"], // يمكن أن تكون null
    emailVerifiedAt: json["email_verified_at"] != null ? DateTime.parse(json["email_verified_at"]) : null, // يمكن أن تكون null
  
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "first_name": firstName,
    "middle_name": middleName, // يمكن أن تكون null
    "last_name": lastName,
    "phone": phone,
    "email": email,
    "identity_number": identityNumber,
    "is_active": isActive,
    "last_login_at": lastLoginAt.toIso8601String(),
    "government_agency_id": governmentAgencyId, // يمكن أن تكون null
    "email_verified_at": emailVerifiedAt?.toIso8601String(), // يمكن أن تكون null

  };
}
