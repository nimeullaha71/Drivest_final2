import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;

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
}
