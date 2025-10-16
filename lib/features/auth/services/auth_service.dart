import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:drivest_office/app/urls.dart';

class AuthService {
  // ✅ Login
  Future<bool> signIn({required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(Urls.signInUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("Login Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Correct token key
        final token = data['accessToken'];
        final refreshToken = data['refreshToken'];
        final name = data['name'] ?? "Guest"; // optional
        final userEmail = email;

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('refreshToken', refreshToken ?? "");
          await prefs.setString('name', name);
          await prefs.setString('email', userEmail);

          print("Token saved: $token"); // Debug

          return true;
        }
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
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