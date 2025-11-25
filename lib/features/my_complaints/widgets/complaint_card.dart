// File: complaint_card.dart

import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/core/widgets/custom_button.dart';
import 'package:internet_application_project/core/resources/responsive_util.dart';

class ComplaintCard extends StatelessWidget {
  const ComplaintCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    // Use ResponsiveUtils for all sizes
    double cardPadding = ResponsiveUtils.cardPadding(
      context,
    ).left; // Use left/horizontal padding
    double iconSize =
        ResponsiveUtils.mediumIconSize(context) *
        1.5; // Slightly larger for emphasis
    double spacing = ResponsiveUtils.smallSpacing(context);
    double titleFont = ResponsiveUtils.bodyTextSize(context);
    double buttonHeight = ResponsiveUtils.buttonHeight(context);
    double buttonFontSize = ResponsiveUtils.bodyTextSize(context) * 0.95;

    // Adjust margin based on whether it's in a ListView (Mobile) or GridView (Tablet/Desktop)
    // The parent list/grid handles the main spacing, so we can simplify the card's own margin.
    EdgeInsets cardMargin = isMobile
        ? EdgeInsets
              .zero // Margin is handled by ListView.builder padding
        : EdgeInsets.zero; // Margin is handled by GridView.builder spacing

    return Container(
      margin: cardMargin,
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
        // Change Row to Column to better handle text wrapping on smaller screens
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and main info section
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: spacing * 2,
                  top:
                      spacing *
                      2, // Adjusted top padding for vertical alignment
                ),
                child: Icon(
                  Icons.description_outlined,
                  size: iconSize,
                  color: darkBrown,
                ),
              ),

              // ------------ TEXT SECTION ------------
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLine("Type of complaint: Service Issue", titleFont),
                    SizedBox(height: spacing),
                    _buildLine("Date: 2023-11-23  Time: 10:30 AM", titleFont),
                    SizedBox(height: spacing),
                    _buildLine(
                      "Governmental entity: Ministry of Water",
                      titleFont,
                    ),
                    SizedBox(height: spacing),
                    _buildLine(
                      "Description: Water supply disruption for 48h.",
                      titleFont,
                    ),
                    SizedBox(height: spacing),
                    _buildLine("Status: New", titleFont),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: spacing * 3),

          // -------- Buttons --------
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  height: buttonHeight,
                  title: 'View details',
                  fontSize: buttonFontSize,
                  width: 0,
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: CustomButton(
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

  // Helper for repeated text style
  Widget _buildLine(String text, double fontSize) {
    return Text(
      text,
      // You should replace primaryColor with the actual color definition
      style: TextStyle(
        color: primaryColor,
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
