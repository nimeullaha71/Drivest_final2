import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:drivest_office/app/urls.dart'; 

class AuthService {
  Future<bool> signIn({
    required String email,
    required String password,
    bool remember = false,
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


        if (data['accessToken'] != null) {
          await prefs.setString('token', data['accessToken']);
        }

        if (data['trialExpired'] == true) {
          throw Exception("TRIAL_EXPIRED");
        }

        return true;
      }

      if (response.statusCode == 403) {
        final prefs = await SharedPreferences.getInstance();
        if (data['accessToken'] != null) {
          await prefs.setString('token', data['accessToken']);
        }
        throw Exception("TRIAL_EXPIRED");
      }

      throw Exception("LOGIN_FAILED: ${response.statusCode}");
    } catch (e) {
      print("Login Error: $e");
      rethrow;
    }
  }


  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('name');
  }

  Future<Map<String, String>> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'Guest',
      'email': prefs.getString('email') ?? 'guest@gmail.com',
    };
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');

  }

  Future<bool> deactivateUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      if (token == null) return false;

      final response = await http.put(
        Uri.parse(Urls.deActivatedUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      if (response.statusCode == 200) {
        // token clear korbo
        prefs.remove("token");
        return true;
      }
      return false;
    } catch (e) {
      print("Deactivate Error: $e");
      return false;
    }
  }



}