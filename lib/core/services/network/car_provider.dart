import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:drivest_office/app/urls.dart';
import 'package:drivest_office/home/model/car_model.dart';

class CarProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<CarModel> _cars = [];

  bool get isLoading => _isLoading;
  List<CarModel> get cars => _cars;

  Future<void> fetchCars({String? search, Map<String, dynamic>? filters}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final queryParams = {
        'status': 'published',
        'page': '1',
        'limit': '100',
        'sort': '-publishedAt',
        if (search != null && search.isNotEmpty) 'q': search,
      };

      if (filters != null) {
        filters.forEach((key, value) {
          if (value != null && value.toString().isNotEmpty) {
            queryParams[key] = value.toString();
          }
        });
      }

      final uri = Uri.parse(Urls.carsUrl)
          .replace(queryParameters: queryParams);

      final res = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        if (data['success'] == true && data['data'] != null) {
          final List items = data['data'];
          _cars = items.map((json) => CarModel.fromJson(json)).toList();
        } else {
          _cars = [];
        }
      } else {
        debugPrint('Failed to load cars: ${res.statusCode}');
        _cars = [];
      }
    } catch (e) {
      debugPrint('API error: $e');
      _cars = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
