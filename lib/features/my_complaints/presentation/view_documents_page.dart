import 'package:flutter/material.dart';
import 'package:internet_application_project/core/widgets/customAppBar.dart';

class ViewDocumentsPage extends StatelessWidget {
  const ViewDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'View documents', icon: Icons.arrow_back),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
