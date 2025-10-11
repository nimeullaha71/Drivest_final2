import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';
import 'package:flutter/material.dart';
import '../model/notification_model.dart';
import 'notification_detail_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [
    NotificationModel(
      icon: Icons.message,
      iconColor: Colors.blue,
      title: "Message alert!",
      subtitle: "You've received a new message from John.",
      time: "4:46 PM",
    ),
    NotificationModel(
      icon: Icons.calendar_today,
      iconColor: Colors.brown,
      title: "Booking Confirmation",
      subtitle: "Viewing confirmed for Saturday at 2:00 PM.",
      time: "2:24 PM",
    ),
    NotificationModel(
      icon: Icons.directions_car,
      iconColor: Colors.green,
      title: "New Car Alert",
      subtitle: "New listing: You have a new car available.",
      time: "yesterday",
    ),
    NotificationModel(
      icon: Icons.warning,
      iconColor: Colors.orange,
      title: "Listing Expired",
      subtitle: "Heads up! The 1BR Apartment in Uptown has expired.",
      time: "09/05/25",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: DrivestAppBar(title: "Notification"),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications available",
                style: TextStyle(fontSize: 16, color: Color(0xff333333),),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: item.iconColor.withOpacity(0.1),
                    child: Text(
                      "${index + 1}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Color(0xff0A0A0A),
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    item.time,
                    style: TextStyle(color: Color(0xff333333), fontSize: 12,fontWeight: FontWeight.w400),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NotificationDetailScreen(
                          notification: item,
                          index: index + 1,
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
