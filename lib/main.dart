import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'core/services/network/car_provider.dart';
import 'core/services/network/user_provider.dart';
import 'home/controller/saved_car_controller.dart';

void main() {
  Get.put(SavedCarController());

  Get.put(SavedCarController(), permanent: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
