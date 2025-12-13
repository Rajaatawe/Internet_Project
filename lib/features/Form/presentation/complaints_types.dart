import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';
import 'package:internet_application_project/features/Form/presentation/preview.dart';

class ComplaintsTypes extends StatelessWidget {
  final int agencyId;

  const ComplaintsTypes({
    super.key,
    required this.agencyId,
  });

  static const List<Map<String, dynamic>> complaintTypes = [
    {
      "title": "Road Damage",
      "icon": Icons.directions_walk,
    },
    {
      "title": "Electricity Outage",
      "icon": Icons.electrical_services,
    },
    {
      "title": "Water Leakage",
      "icon": Icons.water_damage,
    },
    {
      "title": "Garbage Issue",
      "icon": Icons.delete,
    },
    {
      "title": "Public Safety",
      "icon": Icons.security,
    },
    {
      "title": "Other",
      "icon": Icons.more_horiz,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Complaint Types',
        icon: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.05,
          vertical: size.height * 0.02,
        ),
        child: ListView.separated(
          itemCount: complaintTypes.length,
          separatorBuilder: (_, __) => SizedBox(
            height: size.height * 0.02,
          ),
          itemBuilder: (context, index) {
            final item = complaintTypes[index];

            return InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => Preview(
                      complaintType: 'item.title',
                      agencyId: agencyId,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.04,
                  vertical: size.height * 0.011,
                ),
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        item["icon"],
                        color: primaryColor,
                        size: isTablet ? 36 : 28,
                      ),
                    ),
                    SizedBox(width: size.width * 0.05),
                    Expanded(
                      child: Text(
                        item["title"],
                        style: TextStyle(
                          fontSize: isTablet ? 22 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white70,
                      size: 18,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
