import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'app/app.dart';
import 'home/controller/saved_car_controller.dart';

void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  Get.put(SavedCarController());
  runApp(const MyApp());
}
