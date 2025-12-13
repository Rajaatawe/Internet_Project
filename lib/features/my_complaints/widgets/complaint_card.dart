// File: complaint_card.dart

import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';
import 'package:internet_application_project/features/my_complaints/presentation/view_documents_page.dart';
import 'package:internet_application_project/features/my_complaints/widgets/complaint_card_details.dart';
import 'package:latlong2/latlong.dart';
import 'package:internet_application_project/core/models/complaints_model.dart';

class ComplaintCard extends StatelessWidget {
  final Complaint complaint;

  const ComplaintCard({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    double cardPadding = ResponsiveUtils.cardPadding(context).left;
    double iconSize = ResponsiveUtils.mediumIconSize(context) * 1.5;
    double spacing = ResponsiveUtils.smallSpacing(context);
    double titleFont = ResponsiveUtils.bodyTextSize(context);
    double buttonHeight = ResponsiveUtils.buttonHeight(context);
    double buttonFontSize = ResponsiveUtils.bodyTextSize(context) * 0.95;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: whiteBrown,
        borderRadius: BorderRadius.circular(
          ResponsiveUtils.mediumBorderRadius(context),
        ),
        boxShadow: [
          BoxShadow(
            color: darkBrown.withOpacity(0.3),
            blurRadius: ResponsiveUtils.smallElevation(context),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon + info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(right: spacing * 2, top: spacing * 2),
                child: Icon(
                  Icons.description_outlined,
                  size: iconSize,
                  color: darkBrown,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLine(
                      "Type of complaint: ${complaint.complaintType.name}",
                      titleFont,
                    ),
                    SizedBox(height: spacing),
                    _buildLine(
                      "Date: ${complaint.createdAt.toLocal().toString().split(' ')[0]} "
                      "Time: ${TimeOfDay.fromDateTime(complaint.createdAt).format(context)}",
                      titleFont,
                    ),
                    SizedBox(height: spacing),
                    _buildLine(
                      "Governmental entity: ${complaint.governmentAgency.agencyName}",
                      titleFont,
                    ),
                    SizedBox(height: spacing),
                    _buildLine(
                      "Status: ${complaint.status}",
                      titleFont,
                      color: _statusColor(complaint.status),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: spacing * 2),
          // Buttons
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: Colors.transparent,
                          child: ComplaintCardDetails(
                            description: complaint.description,
                            address:
                                "${complaint.latitude}, ${complaint.longitude}",
                            location: LatLng(
                              double.parse(complaint.latitude),
                              double.parse(complaint.longitude),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  height: buttonHeight,
                  title: 'View details',
                  fontSize: buttonFontSize,
                  width: 0,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: CustomButton(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ViewDocumentsPage(mediaList: complaint.media),
                      ),
                    );
                  },
                  height: buttonHeight,
                  title: 'View documents',
                  fontSize: buttonFontSize,
                  width: 0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper
  Widget _buildLine(String text, double fontSize, {Color? color}) {
    return Text(
      text,
      style: TextStyle(
        color: color ?? primaryColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'new':
        return Colors.blue;
      case 'in_process':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'done':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
