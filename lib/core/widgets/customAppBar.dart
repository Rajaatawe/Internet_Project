import 'package:flutter/material.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
    required this.icon,
    this.tabbar,
  }) : super(key: key);

  final String title;
  final IconData icon;

  final PreferredSizeWidget? tabbar;

  @override
  Size get preferredSize => Size.fromHeight(56.0); //عتد عمل appbar خاص فينا يجب ان نقوم ب implements ل preferredsizedwidget لكي نحدد ارتفاع الاب بار وهذا ضروري

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: fourthColor.withValues(alpha: 0.8),
      centerTitle: true,
      title: Text(title),
      titleTextStyle: TextStyle(
        color: darkBrown,
        fontWeight: FontWeight.w500,
        fontSize: 28,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(icon, color: darkBrown),
      ),
      bottom: tabbar,
    );
  }
}
