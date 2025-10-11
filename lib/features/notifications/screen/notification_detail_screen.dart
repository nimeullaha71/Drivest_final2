import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../model/notification_model.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel notification;
  final int index;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(title: "Notification #$index",),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: notification.iconColor.withOpacity(0.1),
                  child: Icon(notification.icon, color: notification.iconColor),
                ),
                const SizedBox(width: 10),
                Text(
                  notification.time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              notification.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              notification.subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
