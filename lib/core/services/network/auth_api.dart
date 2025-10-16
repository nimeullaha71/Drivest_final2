import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Urls.signUpUrl),
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );
      print("this is the respone : ${response.body}");

      print("Status Code : ${response.statusCode}");

      if (response.statusCode == 201) {
        print("User successfully saved to backend");
        return true;
      } else {
        print("error: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Network Error: $e");
      return false;
    }
  }


  static Future<Map<String, dynamic>> forgotPassword(String email) async {
    final url = Uri.parse(Urls.forgotPassUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send reset code');
    }
  }

  static Future<Map<String, dynamic>> verifyForgotPasswordOtp(
      String email, String otp) async {
    final url = Uri.parse(Urls.verifyOtpUrl);
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to verify OTP");
    }
  }

  static Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final url = Uri.parse(Urls.resetPassUrl);

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'newPassword': newPassword,
        }),
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        return {
          'success': false,
          'message': 'Failed to reset password. Status: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error: ${e.toString()}',
      };
    }
  }

// ApiService.dart এ এই METHOD ADD/REPLACE করুন:
  static Future<Map<String, dynamic>?> getUserProfileWithToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print("🔥 Token: $token"); // ✅ DEBUG

      if (token == null || token.isEmpty) {
        print("❌ No Token Found!");
        return null;
      }

      final response = await http.get( // ✅ GET method
        Uri.parse(Urls.userProfileUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // ✅ Bearer Token
        },
      );

      print("🔥 Profile API Response: ${response.statusCode}"); // ✅ DEBUG
      print("🔥 Profile API Body: ${response.body}"); // ✅ DEBUG

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final user = data['user'] ?? data; // ✅ Flexible response
        print("✅ User Data: $user"); // ✅ DEBUG
        return user;
      } else {
        print("❌ Profile API Error: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("❌ Profile Exception: $e");
      return null;
    }
  }
}
