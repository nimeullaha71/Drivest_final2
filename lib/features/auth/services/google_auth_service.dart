import 'dart:convert';
import 'package:drivest_office/app/urls.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  /// Google Sign-In Function
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      // Step 1️⃣: Google Sign-In popup দেখাও
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User cancelled
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Sign-in cancelled")));
        return;
      }

      // Step 2️⃣: Google Auth token নাও
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final tokenId = googleAuth.idToken;

      if (tokenId == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Failed to get ID Token")));
        return;
      }

      // Step 3️⃣: Backend এ পাঠাও
      final response = await http.post(
        Uri.parse(Urls.signInWithGoogleUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": tokenId}),
      );

      final data = jsonDecode(response.body);

      // Step 4️⃣: Success হলে token save করো
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", data["token"]);

        // Optional: user info store করতে পারো
        await prefs.setString("user", jsonEncode(data["user"]));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In Successful!")),
        );

        // Navigate to main screen (যেমন home page)
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Login failed: ${data["message"] ?? "Unknown error"}")),
        );
      }
    } catch (e) {
      debugPrint("Google Sign-In Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Something went wrong: $e")),
      );
    }
  }

  /// Optional: Sign Out
  // Future<void> signOut(BuildContext context) async {
  //   await _googleSignIn.signOut();
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove("token");
  //   await prefs.remove("user");
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(content: Text("Signed out successfully")),
  //   );
  // }
}
