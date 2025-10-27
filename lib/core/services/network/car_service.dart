import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../home/model/car_model.dart';

class CarService {
  static Future<List<CarModel>> fetchFeaturedCars() async {
    try {
      // 🔹 Get saved token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // 🔹 Send GET request with Authorization header
      final response = await http.get(
        Uri.parse(Urls.carsUrl),
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      );

      print("🔹 Cars API Status: ${response.statusCode}");
      print("🔹 Cars API Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["data"] != null) {
          final List carsJson = data["data"];
          return carsJson.map((json) => CarModel.fromJson(json)).toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load cars: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cars: $e');
    }
  }
}
