import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:http/http.dart' as http;

class TradeAnalysisAPI {

// ✅ CHANGE RETURN TYPE + PARSING
  static Future<Map<String, dynamic>> analyzeCar(Map<String, dynamic> carData) async {
    final response = await http.post(
      Uri.parse(Urls.carAnalyzeUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({"cars": [carData]}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result["data"][0]; // ✅ extract only the first analysis object
    } else {
      throw Exception("Failed to analyze car: ${response.body}");
    }
  }

}
