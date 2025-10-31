import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:drivest_office/app/urls.dart';

class AuthService {
  // ✅ Login
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Urls.signInUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      print("🔹 Login Response: $data");

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        // Save token if exists
        if (data['accessToken'] != null) {
          await prefs.setString('token', data['accessToken']);
        }

        // Check trial expired in response
        if (data['trialExpired'] == true) {
          throw Exception("TRIAL_EXPIRED"); // Your SignInScreen will handle this
        }

        return true; // Normal login
      }

      // 🔹 If status code is 403 → trial expired / payment needed
      if (response.statusCode == 403) {
        final prefs = await SharedPreferences.getInstance();
        if (data['accessToken'] != null) {
          await prefs.setString('token', data['accessToken']);
        }
        throw Exception("TRIAL_EXPIRED"); // SignInScreen will navigate
      }

      throw Exception("LOGIN_FAILED: ${response.statusCode}");
    } catch (e) {
      print("Login Error: $e");
      rethrow; // Let SignInScreen catch this and navigate
    }
  }


  // ✅ Logout
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('name');
  }

  // ✅ Get user info
  Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'Guest',
      'email': prefs.getString('email') ?? 'guest@gmail.com',
    };
  }

  // ✅ Get token for API calls
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}