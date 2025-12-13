// To parse this JSON data, do
//
//     final complaintsTypes = complaintsTypesFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ComplaintsTypes complaintsTypesFromJson(String str) => ComplaintsTypes.fromJson(json.decode(str));

String complaintsTypesToJson(ComplaintsTypes data) => json.encode(data.toJson());

class ComplaintsTypes {
    final bool success;
    final String message;
    final List<ComplaintType> data;

    ComplaintsTypes({
        required this.success,
        required this.message,
        required this.data,
    });

    factory ComplaintsTypes.fromJson(Map<String, dynamic> json) => ComplaintsTypes(
        success: json["success"],
        message: json["message"],
        data: List<ComplaintType>.from(json["data"].map((x) => ComplaintType.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class ComplaintType {
    final int id;
    final int governmentAgencyId;
    final String name;
    final bool isOtherOption;
    final DateTime createdAt;
    final DateTime updatedAt;

    ComplaintType({
        required this.id,
        required this.governmentAgencyId,
        required this.name,
        required this.isOtherOption,
        required this.createdAt,
        required this.updatedAt,
    });

    factory ComplaintType.fromJson(Map<String, dynamic> json) => ComplaintType(
        id: json["id"],
        governmentAgencyId: json["government_agency_id"],
        name: json["name"],
        isOtherOption: json["is_other_option"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "government_agency_id": governmentAgencyId,
        "name": name,
        "is_other_option": isOtherOption,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
