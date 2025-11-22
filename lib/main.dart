import 'dart:async';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'app/app.dart';
import 'core/services/network/car_provider.dart';
import 'core/services/network/user_provider.dart';
import 'features/notifications/services/notification_count_provider.dart';
import 'home/controller/saved_car_controller.dart';

StreamSubscription<Uri>? _linkSub;
AppLinks? _appLinks;

void main() {
  Get.put(SavedCarController());
  Get.put(SavedCarController(), permanent: true);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => NotificationCountProvider()),
        ChangeNotifierProvider(create: (_) => CarProvider()),
      ],
      child: const MyApp(),
    ),
  );

  initDeepLinks();
}

Future<void> initDeepLinks() async {
  debugPrint('INIT: initDeepLinks() called');            // ✅ A
  _appLinks ??= AppLinks();

  // ✅ Cold start
  try {
    final initial = await _appLinks!.getInitialLink();
    debugPrint('INIT: getInitialLink() => $initial');    // ✅ B
    if (initial != null) _handleUri(initial);
  } catch (e) {
    debugPrint('INIT ERROR: $e');
  }

  // ✅ Warm/foreground
  _linkSub?.cancel();
  _linkSub = _appLinks!.uriLinkStream.listen((uri) {
    debugPrint('STREAM: $uri');                          // ✅ C
    _handleUri(uri);
  }, onError: (err) {
    debugPrint('Deep link stream error: $err');
  });
}

void _handleUri(Uri uri) {
  debugPrint('DEEP LINK => $uri');

  // drivest://ride/69  এবং drivest:///ride/69 — দুটোই সাপোর্ট
  final segments = uri.host.isEmpty
      ? uri.pathSegments
      : [uri.host, ...uri.pathSegments];

  if (segments.isEmpty) {
    Get.snackbar('Deep Link', 'Invalid or empty link');
    return;
  }

  final first = segments[0];

  // ✅ fixed: drivest://ride/69
  if (first == 'ride' && segments.length >= 2 && segments[1] == '69') {
    Get.snackbar('Deep Link', 'Ride 69 opened successfully!');
    return;
  }

  // ✅ fixed: drivest://profile/nime
  if (first == 'profile' && segments.length >= 2 && segments[1] == 'nime') {
    Get.snackbar('Deep Link', 'Welcome, Nime!');
    return;
  }

  debugPrint('Invalid deep link: $uri');
  Get.snackbar('Deep Link', 'Invalid link: $uri');
}
