// To parse this JSON data:
//
//     final complaintsModel = complaintsModelFromJson(jsonString);

import 'dart:convert';

ComplaintsModel complaintsModelFromJson(String str) =>
    ComplaintsModel.fromJson(json.decode(str));

String complaintsModelToJson(ComplaintsModel data) =>
    json.encode(data.toJson());

class ComplaintsModel {
  final bool success;
  final String message;
  final List<Complaint> data;

  ComplaintsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ComplaintsModel.fromJson(Map<String, dynamic> json) =>
      ComplaintsModel(
        success: json["success"],
        message: json["message"],
        data: List<Complaint>.from(
          json["data"].map((x) => Complaint.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Complaint {
  final int id;
  final String referenceCode;
  final String title;
  final String description;
  final String status;
  final String latitude;
  final String longitude;
  final GovernmentAgency governmentAgency;
  final ComplaintType complaintType;
  final List<Media> media;
  final AssignedTo? assignedTo; // Nullable (some complaints may not be assigned)
  final DateTime createdAt;
  final DateTime updatedAt;

  Complaint({
    required this.id,
    required this.referenceCode,
    required this.title,
    required this.description,
    required this.status,
    required this.latitude,
    required this.longitude,
    required this.governmentAgency,
    required this.complaintType,
    required this.media,
    required this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
        id: json["id"],
        referenceCode: json["reference_code"],
        title: json["title"],
        description: json["description"],
        status: json["status"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        governmentAgency:
            GovernmentAgency.fromJson(json["government_agency"]),
        complaintType: ComplaintType.fromJson(json["complaint_type"]),
        media: List<Media>.from(
          json["media"].map((x) => Media.fromJson(x)),
        ),
        assignedTo: json["assigned_to"] == null
            ? null
            : AssignedTo.fromJson(json["assigned_to"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reference_code": referenceCode,
        "title": title,
        "description": description,
        "status": status,
        "latitude": latitude,
        "longitude": longitude,
        "government_agency": governmentAgency.toJson(),
        "complaint_type": complaintType.toJson(),
        "media": List<dynamic>.from(media.map((x) => x.toJson())),
        "assigned_to": assignedTo?.toJson(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class AssignedTo {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;

  AssignedTo({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
  });

  factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        phone: json["phone"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
      };
}

class ComplaintType {
  final int id;
  final String name;

  ComplaintType({
    required this.id,
    required this.name,
  });

  factory ComplaintType.fromJson(Map<String, dynamic> json) => ComplaintType(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class GovernmentAgency {
  final int id;
  final String agencyName;
  final String email;
  final String phone;

  GovernmentAgency({
    required this.id,
    required this.agencyName,
    required this.email,
    required this.phone,
  });

  factory GovernmentAgency.fromJson(Map<String, dynamic> json) =>
      GovernmentAgency(
        id: json["id"],
        agencyName: json["agency_name"],
        email: json["email"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agency_name": agencyName,
        "email": email,
        "phone": phone,
      };
}

class Media {
  final int id;
  final String url;

  Media({
    required this.id,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) => Media(
        id: json["id"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
      };
}
