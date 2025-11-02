import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../app/urls.dart';

class SubscriptionService {
  static Future<void> createSubscription(BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.post(
        Uri.parse(Urls.createStripeSessionUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final stripeUrl = data['url'];

        if (stripeUrl != null) {
          // ✅ Open Stripe checkout page
          if (await canLaunchUrl(Uri.parse(stripeUrl))) {
            await launchUrl(Uri.parse(stripeUrl),
                mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $stripeUrl';
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Stripe URL not found")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create subscription")),
        );
      }
    } catch (e) {
      print("Subscription Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }
}
