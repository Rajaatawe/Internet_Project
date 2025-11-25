import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';

class TitleSettingsRows extends StatelessWidget {
  const TitleSettingsRows({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.061,
      width: MediaQuery.of(context).size.width,
      color: whiteBrown,
      child: Align(
        alignment: AlignmentGeometry.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:  16.0),
          child: Text(title, style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,

          ),),
        ),
      ),
    );
  }
}