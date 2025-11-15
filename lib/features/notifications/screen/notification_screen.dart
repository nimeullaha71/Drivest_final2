import 'package:drivest_office/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../model/notification_model.dart';
import '../services/notification_service.dart';
import 'notification_detail_screen.dart';
import 'package:drivest_office/home/widgets/profile_page_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  fetchNotifications() async {
    try {
      String? token = await AuthService().getToken(); // nullable

      if (token == null) {
        print("Token not found!");
        setState(() => isLoading = false);
        return;
      }

      final list = await NotificationService.getNotifications(token);

      setState(() {
        notifications = list;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error: $e");
    }
  }


  String formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DrivestAppBar(title: "Notification"),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : notifications.isEmpty
          ? const Center(
        child: Text(
          "No notifications available",
          style: TextStyle(fontSize: 16, color: Color(0xff333333)),
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
              radius: 22,
              backgroundColor: Colors.blue.withOpacity(0.1),
              child: Icon(Icons.notifications, color: Colors.blue),
            ),
            title: Text(
              "New Notification",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              item.message,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Text(
              formatTime(item.createdAt),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
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
