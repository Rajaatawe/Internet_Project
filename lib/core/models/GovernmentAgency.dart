
import 'dart:convert';

GovernmentAgency governmentAgencyFromJson(String str) => GovernmentAgency.fromJson(json.decode(str));

String governmentAgencyToJson(GovernmentAgency data) => json.encode(data.toJson());

class GovernmentAgency {
    final bool success;
    final String message;
    final List<GovernmentAgencyclass> data;

    GovernmentAgency({
        required this.success,
        required this.message,
        required this.data,
    });

    factory GovernmentAgency.fromJson(Map<String, dynamic> json) => GovernmentAgency(
        success: json["success"],
        message: json["message"],
        data: List<GovernmentAgencyclass>.from(json["data"].map((x) => GovernmentAgencyclass.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class GovernmentAgencyclass {
    final int id;
    final String agencyName;
    final String email;
    final String phone;

    GovernmentAgencyclass({
        required this.id,
        required this.agencyName,
        required this.email,
        required this.phone,
    });

    factory GovernmentAgencyclass.fromJson(Map<String, dynamic> json) => GovernmentAgencyclass(
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
