import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? gender;


  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int,
    name: json['name'] as String,
    email: json['email'] as String,
    phone: json['phone'] as String,
    gender: json['gender'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'gender': gender,
  };

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    gender,
  ];

  User copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? accountType,
    String? deviceToken,
    bool? isApproved,
  }) {
    return User(
      id: id ?? this.id,
      name: firstName ?? this.name,
      email: lastName ?? this.email,
      phone: phone ?? this.phone,
      gender: accountType ?? this.gender,
    );
  }
}
