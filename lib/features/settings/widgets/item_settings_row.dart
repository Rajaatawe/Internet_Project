import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';

class ItemSettingsRow extends StatefulWidget {
  const ItemSettingsRow({
    super.key,
    required this.title,
    required this.icon,
    required this.prefixWidget,
  });
  final String title;
  final IconData icon;
  final Widget prefixWidget;
  @override
  State<ItemSettingsRow> createState() => _ItemSettingsRowState();
}

class _ItemSettingsRowState extends State<ItemSettingsRow> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal:  14.0),
        child: Row(
          children: [
            Icon(widget.icon, color: primaryColor,),
            SizedBox(width: 10),
            Text(
              widget.title,
              style: TextStyle(fontSize: 16 ,color: primaryColor, fontWeight: FontWeight.w500),
            ),
            Spacer(),
            widget.prefixWidget,
            SizedBox(width: 20,),
          ],
        ),
      ),
    );
  }
}
