import 'package:flutter/material.dart';
import 'package:internet_application_project/core/models/notification_model.dart';

class NotificationDetailsPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailsPage({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Details"),
        centerTitle: true,
        backgroundColor: theme.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  notification.description,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
               
               
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "Received: ${notification.time}",
                    style:
                        const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
