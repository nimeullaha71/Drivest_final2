import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;

class TradeAnalysisAPI {

  static Future<List<dynamic>> analyzeCar(Map<String, dynamic> carData) async {
    final response = await http.post(
      Uri.parse(Urls.carAnalyzeUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"cars": [carData]}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to analyze car: ${response.body}");
    }
  }
}
