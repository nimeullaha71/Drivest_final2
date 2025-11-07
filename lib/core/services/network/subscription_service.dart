import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../../app/urls.dart';

class SubscriptionService {
  static Future<String?> createSubscriptionUrl(String token) async {
    final response = await http.post(
      Uri.parse(Urls.createStripeSessionUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['url'];
    }
    return null;
  }


  static Future<void> createWebHook(BuildContext context) async {
  }

  static Future<bool> verifyPayment(String token, String sessionId) async {
    try {
      print("🔹 Verifying payment with session_id: $sessionId");
      final response = await http.post(
        Uri.parse(Urls.createStripeSessionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'session_id': sessionId}),
      );

      print("🔹 Verify response code: ${response.statusCode}");
      print("🔹 Verify response body: ${response.body}");
      return response.statusCode == 200;
    } catch (e) {
      print("Webhook verify error: $e");
      return false;
    }
  }


}
