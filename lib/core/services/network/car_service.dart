import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;
import '../../../home/model/car_model.dart';

class CarService {

  static Future<List<CarModel>> fetchFeaturedCars() async {
    try {
      final response = await http.get(Uri.parse(Urls.carsUrl));

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
