import 'package:drivest_office/features/notifications/screen/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopAppBar extends StatefulWidget {
  final double appBarHeight;
  const TopAppBar({super.key, required this.appBarHeight});

  @override
  State<TopAppBar> createState() => _TopAppBarState();
}

class _TopAppBarState extends State<TopAppBar> {
  String displayName = "Guest";
  String displayEmail = "email@gmail.com";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('user_name') ?? "Guest";
      displayEmail = prefs.getString('user_email') ?? "email@gmail.com";
    });
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = widget.appBarHeight;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(24),
        bottomRight: Radius.circular(24),
      ),
      child: Container(
        color: const Color.fromRGBO(1, 80, 147, 1),
        child: Stack(
          children: [
            Positioned(
              top: appBarHeight * 0.25,
              left: 20,
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.asset('assets/images/profile_img.jpg',
                          width: 42, height: 42, fit: BoxFit.cover),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, $displayName',
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      Text(displayEmail,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: appBarHeight * 0.25,
              right: 20,
              child: Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications,
                        size: 32, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationScreen()),
                      );
                    },
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '4',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
