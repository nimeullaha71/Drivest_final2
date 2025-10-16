import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_api.dart';

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? _userData;
  bool _isLoading = false;

  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;

  Future<void> fetchUserProfile() async {
    print("UserProvider: Starting fetch...");
    _isLoading = true;
    notifyListeners();

    _userData = await ApiService.getUserProfileWithToken();

    if (_userData != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _userData!['name'] ?? '');
      await prefs.setString('user_email', _userData!['email'] ?? '');
      await prefs.setString('user_phone', _userData!['phone'] ?? '');
      print("Saved to SharedPrefs: ${_userData!['name']}");
    } else {
      print("No user data received!");
    }

    _isLoading = false;
    notifyListeners();
    print("UserProvider: Fetch complete! Data: $_userData");
  }
}