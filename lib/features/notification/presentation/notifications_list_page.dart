import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/models/notification_model.dart';
import 'package:internet_application_project/core/resources/colorfile.dart';
import 'package:internet_application_project/features/notification/cubit/notification_cubit.dart';
import 'package:internet_application_project/features/notification/presentation/notification_details_page.dart';

class NotificationsListPage extends StatelessWidget {
  const NotificationsListPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: fourthColor,
        title: const Text("Notifications",style: TextStyle(color: darkBrown),),
        centerTitle: true,
      ),
      body: BlocBuilder<NotificationCubit, List<NotificationModel>>(
        builder: (context, notifications) {
          if (notifications.isEmpty) {
            return const Center(child: Text("No notifications yet"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final notification = notifications[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NotificationDetailsPage(
                        notification: notification, 
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          notification.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            notification.time,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
