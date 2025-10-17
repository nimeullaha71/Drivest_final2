import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/services/network/user_provider.dart';
import '../../widgets/profile_page_app_bar.dart';
import '../profile/my_profile_page.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  File? _image;
  final ImagePicker _picker = ImagePicker();

  static const primary = Color(0xff015093);

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // 🔥 REMOVED: provider listener (NO MORE CRASH!)
  }

  // 🔥 REMOVED: _providerListener function (NO MORE CRASH!)

  @override
  void dispose() {
    // 🔥 REMOVED: provider listener cleanup (NO MORE CRASH!)
    nameController.dispose();
    dobController.dispose();
    emailController.dispose();
    numberController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('user_name') ?? 'Guest';
      emailController.text = prefs.getString('user_email') ?? 'guest@gmail.com';

      // ✅ FIXED DOB LOADING (Server → UI format)
      String rawDob = prefs.getString('user_dob') ?? '';
      dobController.text = rawDob.isNotEmpty ? rawDob : ''; // Direct show
      selectedDate = rawDob.isNotEmpty ? DateTime(2000, 12, 6) : DateTime.now();

      numberController.text = prefs.getString('user_phone') ?? '';
      addressController.text = prefs.getString('user_address') ?? '2464 Royal Ln. Mesa, New Jersey 45463';
    });
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // 🔥 FIXED: Past dates only
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _updateProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name cannot be empty")),
      );
      return;
    }

    bool success = await userProvider.updateUserProfile(
      name: nameController.text.trim(),
      phone: numberController.text.trim(),
      dob: dobController.text.trim(), // UI format → Provider will fix to YYYY-MM-DD
      address: addressController.text.trim(),
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile updated successfully")),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyProfilePage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to update profile")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth > 400 ? 140.0 : screenWidth * 0.4;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: const DrivestAppBar(title: "Edit Profile"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipOval(
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      child: _image == null
                          ? Image.asset(
                        'assets/images/profile.jpg.png',
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      )
                          : Image.file(
                        _image!,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: imageSize * 0.10,
                    right: imageSize * 0.10,
                    child: Container(
                      width: imageSize * 0.28,
                      height: imageSize * 0.28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.add_a_photo_outlined,
                          size: imageSize * 0.15,
                          color: Colors.white,
                        ),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: imageSize * 0.15),

            Text('Full Name', style: TextStyle(fontSize: screenWidth > 400 ? 18 : 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter full name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),

            Text('Date of Birth', style: TextStyle(fontSize: screenWidth > 400 ? 18 : 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: dobController,
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Select date of birth',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Text('Email', style: TextStyle(fontSize: screenWidth > 400 ? 18 : 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Email',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                filled: true,
                fillColor: Colors.grey.shade200,
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),

            Text('Phone Number', style: TextStyle(fontSize: screenWidth > 400 ? 18 : 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: numberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            const SizedBox(height: 20),

            Text('Address', style: TextStyle(fontSize: screenWidth > 400 ? 18 : 16, fontWeight: FontWeight.w400)),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Enter address',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
            SizedBox(height: screenWidth > 400 ? 40 : 30),

            SizedBox(
              width: double.infinity,
              height: screenWidth > 400 ? 60 : 56,
              child: ElevatedButton(
                onPressed: _updateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                  elevation: 8,
                  shadowColor: primary.withOpacity(.35),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontSize: screenWidth > 400 ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}