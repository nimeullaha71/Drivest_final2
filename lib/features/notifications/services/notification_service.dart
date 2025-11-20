import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/notification_model.dart';
import '../../../app/urls.dart';  // your base url

class NotificationService {
  static Future<List<NotificationModel>> getNotifications(String token) async {
    final url = Uri.parse(Urls.notificationUrl); // your API endpoint

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      List data = body['data'];

      return data.map((e) => NotificationModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }

  static Future<int> getNotificationCount(String token) async {
    final notifications = await getNotifications(token);
    return notifications.length;
  }
}
