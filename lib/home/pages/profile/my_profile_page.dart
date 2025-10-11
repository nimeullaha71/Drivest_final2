import 'package:drivest_office/home/pages/profile/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../main_bottom_nav_screen.dart';
import '../../widgets/custome_bottom_nav_bar.dart';
import '../../widgets/profile_page_app_bar.dart';
import '../ai_chat_page.dart';
import '../compare_selection_page.dart';
import '../saved_page.dart';

const _primary = Color(0xff015093);
const _cardShadow = Color(0x14000000);
const _tileIconBg = Color(0xffEEF2F6);
const _tileIcon = Color(0xff6E7C8D);
const _chipBg = Color(0xffEAF3FF);

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  int _selectedIndex = 4;

  String displayName = "Guest";
  String displayEmail = "guest@gmail.com";
  String dateOfBirth = "23/09/02";
  String address = "2464 Royal Ln. Mesa, New Jersey 45463";

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      displayName = prefs.getString('user_name') ?? "Guest";
      displayEmail = prefs.getString('user_email') ?? "guest@gmail.com";
      dateOfBirth = prefs.getString('user_dob') ?? "23/09/02";
      address = prefs.getString('user_address') ?? "2464 Royal Ln. Mesa, New Jersey 45463";
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: const DrivestAppBar(title: "My Profile"),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 160,
                        height: 160,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          'assets/images/profile.jpg.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Profile Info
                _buildProfileInfoRow('Full Name:', displayName),
                const SizedBox(height: 16),
                _buildProfileInfoRow('Email/Phone Number:', displayEmail),
                const SizedBox(height: 16),
                _buildProfileInfoRow('Date of Birth:', dateOfBirth),
                const SizedBox(height: 16),
                _buildProfileInfoRow('Address:', address),
                const SizedBox(height: 24),
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: InkWell(
              onTap: () async {
                // Navigate to edit profile page
                final updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  EditProfileScreen()),
                );

                if (updated == true) {
                  _loadUserInfo(); // refresh profile after editing
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.edit,
                  color: _primary,
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) Navigator.push(context, MaterialPageRoute(builder: (context) => MainBottomNavScreen()));
          if (index == 1) Navigator.push(context, MaterialPageRoute(builder: (context) => CompareSelectionPage()));
          if (index == 2) Navigator.push(context, MaterialPageRoute(builder: (context) => SavedPage()));
          if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (context) => AiChatPage()));
        },
      ),
    );
  }

  Widget _buildProfileInfoRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF555555),
          ),
        ),
      ],
    );
  }
}
